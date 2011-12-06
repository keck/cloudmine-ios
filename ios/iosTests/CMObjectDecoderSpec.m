//
//  CMObjectDecoderSpec.m
//  cloudmine-iosTests
//
//  Copyright (c) 2011 CloudMine, LLC. All rights reserved.
//  See LICENSE file included with SDK for details.
//

#import "Kiwi.h"

#import "CMObjectEncoder.h"
#import "CMObjectDecoder.h"
#import "CMSerializable.h"
#import "NSString+UUID.h"
#import "CMGenericSerializableObject.h"

SPEC_BEGIN(CMObjectDecoderSpec)

/**
 * Note: This test relies on the proper functioning of <tt>CMObjectEncoder</tt> to 
 * generate the original dictionary representation of the object and to test
 * the symmetry of the encode/decode methods.
 */
describe(@"CMObjectDecoder", ^{
    it(@"should decode a single object correctly", ^{
        // Create the original object and serialize it. This will serve as the input for the real test.
        CMGenericSerializableObject *originalObject = [[CMGenericSerializableObject alloc] initWithObjectId:[NSString stringWithUUID]];
        [originalObject fillPropertiesWithDefaults];
        NSDictionary *originalObjectDictionaryRepresentation = [CMObjectEncoder encodeObjects:[NSSet setWithObject:originalObject]];
        
        // Create everything needed to decode this representation now.
        NSArray *decodedObjects = [CMObjectDecoder decodeObjects:originalObjectDictionaryRepresentation];
        
        // Test the symmetry.
        [[[decodedObjects should] have:1] items];
        [[[decodedObjects objectAtIndex:0] should] equal:originalObject];
    });
    
    it(@"should decode multiple objects correctly", ^{
        NSMutableArray *originalObjects = [NSMutableArray arrayWithCapacity:5];
        for (int i=0; i<5; i++) {
            CMGenericSerializableObject *obj = [[CMGenericSerializableObject alloc] initWithObjectId:[NSString stringWithUUID]];
            [obj fillPropertiesWithDefaults];
            [originalObjects addObject:obj];
        }
        
        NSDictionary *originalObjectsDictionaryRepresentation = [CMObjectEncoder encodeObjects:originalObjects];
        NSArray *decodedObjects = [CMObjectDecoder decodeObjects:originalObjectsDictionaryRepresentation];
        
        [[[decodedObjects should] have:5] items];
        [decodedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [[obj should] equal:[originalObjects objectAtIndex:idx]];
        }];
    });
});

SPEC_END
