@import CoreData;
@import XCTest;

@import DATAStack;
#import "NSEntityDescription+SYNCPrimaryKey.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (NSEntityDescription *)entityForName:(NSString *)name {
    DATAStack *dataStack = [[DATAStack alloc] initWithModelName:@"Pod"
                                                         bundle:[NSBundle bundleForClass:[self class]]
                                                      storeType:DATAStackStoreTypeInMemory];

    return  [NSEntityDescription entityForName:name
                        inManagedObjectContext:dataStack.mainContext];

}

- (void)testPrimaryKeyAttribute {
    NSEntityDescription *entity = [self entityForName:@"User"];

    NSAttributeDescription *attribute = [entity sync_primaryKeyAttribute];
    XCTAssertEqualObjects(attribute.attributeValueClassName, @"NSNumber");
    XCTAssertEqual(attribute.attributeType, NSInteger32AttributeType);

    entity = [self entityForName:@"Note"];
    attribute = [entity sync_primaryKeyAttribute];
    XCTAssertEqualObjects(attribute.attributeValueClassName, @"NSNumber");
    XCTAssertEqual(attribute.attributeType, NSInteger16AttributeType);

    entity = [self entityForName:@"Tag"];
    attribute = [entity sync_primaryKeyAttribute];
    XCTAssertEqualObjects(attribute.attributeValueClassName, @"NSString");
    XCTAssertEqual(attribute.attributeType, NSStringAttributeType);

    entity = [self entityForName:@"NoID"];
    attribute = [entity sync_primaryKeyAttribute];
    XCTAssertNil(attribute);
}

- (void)testLocalKey {
    NSEntityDescription *entity = [self entityForName:@"User"];

    XCTAssertEqualObjects([entity sync_localKey], @"remoteID");

    entity = [self entityForName:@"Note"];
    XCTAssertEqualObjects([entity sync_localKey], @"uniqueID");

    entity = [self entityForName:@"Tag"];
    XCTAssertEqualObjects([entity sync_localKey], @"randomId");

    entity = [self entityForName:@"NoID"];
    XCTAssertNil([entity sync_localKey]);
}

- (void)testRemoteKey {
    NSEntityDescription *entity = [self entityForName:@"User"];
    XCTAssertEqualObjects([entity sync_remoteKey], @"id");

    entity = [self entityForName:@"Note"];
    XCTAssertEqualObjects([entity sync_remoteKey], @"unique_id");

    entity = [self entityForName:@"Tag"];
    XCTAssertEqualObjects([entity sync_remoteKey], @"id");

    entity = [self entityForName:@"NoID"];
    XCTAssertNil([entity sync_remoteKey]);
}

@end