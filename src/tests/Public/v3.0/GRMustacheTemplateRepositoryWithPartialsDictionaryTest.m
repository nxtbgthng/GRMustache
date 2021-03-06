// The MIT License
// 
// Copyright (c) 2012 Gwendal Roué
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GRMustacheTemplateRepositoryWithPartialsDictionaryTest.h"

@implementation GRMustacheTemplateRepositoryWithPartialsDictionaryTest

- (void)testTemplateRepositoryWithPartialsDictionary
{
    GRMustacheTemplate *template;
    NSString *result;
    NSError *error;
    
    NSDictionary *partials = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"A{{>b}}", @"a",
                              @"B{{>c}}", @"b",
                              @"C",       @"c",
                              nil];
    GRMustacheTemplateRepository *repository = [GRMustacheTemplateRepository templateRepositoryWithPartialsDictionary:partials];
    
    template = [repository templateForName:@"not found" error:&error];
    STAssertNil(template, @"");
    STAssertEqualObjects(error.domain, GRMustacheErrorDomain, @"");
    STAssertEquals((NSInteger)error.code, (NSInteger)GRMustacheErrorCodeTemplateNotFound, @"");
    
    template = [repository templateFromString:@"{{>not found}}" error:&error];
    STAssertNil(template, @"");
    STAssertEqualObjects(error.domain, GRMustacheErrorDomain, @"");
    STAssertEquals((NSInteger)error.code, (NSInteger)GRMustacheErrorCodeTemplateNotFound, @"");
    
    template = [repository templateForName:@"a" error:&error];
    result = [template render];
    STAssertEqualObjects(result, @"ABC", @"");
    
    template = [repository templateFromString:@"{{>a}}" error:&error];
    result = [template render];
    STAssertEqualObjects(result, @"ABC", @"");
}

@end
