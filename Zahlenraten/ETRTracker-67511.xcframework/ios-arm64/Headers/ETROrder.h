//
//  ETROrder.h
//  etracker-tracking-framework-ios
//
//  Copyright etracker GmbH. All rights reserved.
//

#ifndef ETROrder_h
#define ETROrder_h

#define NO_INIT \
- (instancetype)init NS_UNAVAILABLE; \
+ (instancetype)new NS_UNAVAILABLE;

#define DICTIONARY_COMPOSITION \
- (NSUInteger)count; \
- (id)objectForKey:(id)aKey; \
- (NSEnumerator *)keyEnumerator;

//----------------------------------------------------------------------------------------------------------------

@interface ETRProduct : NSDictionary {
    NSDictionary *_dict;
}
NO_INIT
DICTIONARY_COMPOSITION

- (instancetype) initWithId:(NSString*)id name:(NSString*)name category:(NSArray<NSString*> *)category price:(NSString*)price currency:(NSString*)currency;
- (instancetype) initWithId:(NSString*)id name:(NSString*)name price:(NSString*)price currency:(NSString*)currency;

@end

//----------------------------------------------------------------------------------------------------------------

@interface ETRQuantifiedProduct : NSDictionary {
    NSDictionary *_dict;
}
NO_INIT
DICTIONARY_COMPOSITION

- (instancetype) initWithProduct:(ETRProduct*)product quantity:(NSNumber*)quantity;

@end

//----------------------------------------------------------------------------------------------------------------

@interface ETRBasket : NSDictionary {
    NSDictionary *_dict;
}
NO_INIT
DICTIONARY_COMPOSITION

- (instancetype) initWithId:(NSString*)id  products:(NSArray<ETRQuantifiedProduct*>*)products;

@end

//----------------------------------------------------------------------------------------------------------------

@interface ETROrder : NSDictionary {
    NSDictionary *_dict;
}
NO_INIT
DICTIONARY_COMPOSITION

- (instancetype) initWithOrderNumber:(NSString*)orderNumber status:(NSString*)status orderPrice:(NSString*)orderPrice currency:(NSString*)currency basket:(ETRBasket*)basket customerGroup:(NSString*)customerGroup deliveryConditions:(NSString*)deliveryConditions paymentConditions:(NSString*)paymentConditions;

- (instancetype) initWithOrderNumber:(NSString*)orderNumber status:(NSString*)status orderPrice:(NSString*)orderPrice currency:(NSString*)currency basket:(ETRBasket*)basket;
@end

#endif /* ETROrder_h */
