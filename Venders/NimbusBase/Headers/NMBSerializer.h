//
//  NMBSerializer.h
//  NimbusBase
//
//  Created by William Remaerd on 3/27/14.
//  Copyright (c) 2014 NimbusBase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSAttributeDescription, NSEntityDescription;

/**
 * The instance confirms this protocol is responsible to serialize the object can't be translated to JSON directly.
 */

@protocol NMBSerializer <NSObject>

/**
 * @brief Serialize the value with given information.
 *
 * @param value The value should be serialized.
 * @param attribute From what attribute the value comes.
 * @param entity To which entity the attribute belongs.
 * @param context To identidy the caller of this method.
 *
 * @return The serialized value.
 *
 * @discussion If you don't want serialize the value, just return it directly.
 */
- (id)serialize:(id)value
      attribute:(NSAttributeDescription *)attribute
       ofEntity:(NSEntityDescription *)entity
        context:(id)context;

/**
 * @brief Deserialize the value with give information.
 *
 * @param value The value should be deserialized.
 * @param attribute From what attribute the value comes.
 * @param entity To which entity the attribute belongs.
 * @param context To identidy the caller of this method.
 *
 * @return The deserialized value.
 *
 * @discussion If you don't want deserialize the value, just return it directly.
 */
- (id)deserialize:(id)value
        attribute:(NSAttributeDescription *)attribute
         ofEntity:(NSEntityDescription *)entity
          context:(id)context;

@end

