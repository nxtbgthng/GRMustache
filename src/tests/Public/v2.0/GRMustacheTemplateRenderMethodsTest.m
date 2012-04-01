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

#import "GRMustacheTemplateRenderMethodsTest.h"
#import "JSONKit.h"

@interface GRMustacheTemplateRenderMethodsTestSupport: NSObject
@property (nonatomic, retain) NSString *stringProperty;
@property (nonatomic) BOOL BOOLProperty;
@property (nonatomic) bool boolProperty;
@end

@implementation GRMustacheTemplateRenderMethodsTestSupport
@synthesize stringProperty;
@synthesize BOOLProperty;
@synthesize boolProperty;
@end

@interface GRMustacheTemplateRenderMethodsTest()
@property (nonatomic, readonly) NSString *templateName;
@property (nonatomic, readonly) NSURL *templateURL;
@property (nonatomic, readonly) NSString *templatePath;
@property (nonatomic, readonly) NSString *templateString;
@end

@implementation GRMustacheTemplateRenderMethodsTest

- (NSURL *)templateURL
{
    return [self.testBundle URLForResource:self.templateName withExtension:@"mustache"];
}

- (NSString *)templatePath
{
    return [self.templateURL path];
}

- (NSString *)templateString
{
    return [NSString stringWithContentsOfFile:self.templatePath encoding:NSUTF8StringEncoding error:NULL];
}

- (NSString *)templateName
{
    return @"GRMustacheTemplateRenderMethodsTest";
}

- (id)valueForKey:(NSString *)key inRendering:(NSString *)rendering
{
    NSError *error;
    id object = [rendering objectFromJSONStringWithParseOptions:JKParseOptionNone error:&error];
    STAssertNotNil(object, @"%@", error);
    return [object valueForKey:key];
}

- (BOOL)valueForBOOLPropertyInRendering:(NSString *)rendering
{
    id value = [self valueForKey:@"BOOLProperty" inRendering:rendering];
    STAssertNotNil(value, @"nil BOOLProperty");
    return [(NSNumber *)value boolValue];
}

- (BOOL)valueForboolPropertyInRendering:(NSString *)rendering
{
    id value = [self valueForKey:@"boolProperty" inRendering:rendering];
    STAssertNotNil(value, @"nil boolProperty");
    return [(NSNumber *)value boolValue];
}

- (NSString *)valueForStringPropertyInRendering:(NSString *)rendering
{
    return [self valueForKey:@"stringProperty" inRendering:rendering];
}

- (NSString *)extensionOfTemplateFileInRendering:(NSString *)rendering
{
    NSString *fileName = [self valueForKey:@"fileName" inRendering:rendering];
    return [fileName pathExtension];
}

- (void)testGRMustacheTemplate_renderObject_fromString_error
{
    GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
    context.stringProperty = @"foo";
    NSString *rendering = [GRMustacheTemplate renderObject:context
                                                fromString:self.templateString
                                                     error:NULL];
    STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
}

- (void)testGRMustacheTemplate_renderObject_fromString_options_error
{
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                                    fromString:self.templateString
                                                       options:GRMustacheTemplateOptionNone
                                                         error:NULL];
        STAssertEquals(NO, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
    }
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                                    fromString:self.templateString
                                                       options:GRMustacheTemplateOptionStrictBoolean
                                                         error:NULL];
        STAssertEquals(YES, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
    }
}

- (void)testGRMustacheTemplate_renderObject_fromContentsOfFile_error
{
    GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
    context.stringProperty = @"foo";
    NSString *rendering = [GRMustacheTemplate renderObject:context
                                        fromContentsOfFile:self.templatePath
                                                     error:NULL];
    STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
}

- (void)testGRMustacheTemplate_renderObject_fromContentsOfFile_options_error
{
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                            fromContentsOfFile:self.templatePath
                                                       options:GRMustacheTemplateOptionNone
                                                         error:NULL];
        STAssertEquals(NO, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
    }
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                            fromContentsOfFile:self.templatePath
                                                       options:GRMustacheTemplateOptionStrictBoolean
                                                         error:NULL];
        STAssertEquals(YES, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
    }
}

- (void)testGRMustacheTemplate_renderObject_fromContentsOfURL_error
{
    GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
    context.stringProperty = @"foo";
    NSString *rendering = [GRMustacheTemplate renderObject:context
                                         fromContentsOfURL:self.templateURL
                                                     error:NULL];
    STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
}

- (void)testGRMustacheTemplate_renderObject_fromContentsOfURL_options_error
{
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                             fromContentsOfURL:self.templateURL
                                                       options:GRMustacheTemplateOptionNone
                                                         error:NULL];
        STAssertEquals(NO, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
    }
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                             fromContentsOfURL:self.templateURL
                                                       options:GRMustacheTemplateOptionStrictBoolean
                                                         error:NULL];
        STAssertEquals(YES, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
    }
}

- (void)testGRMustacheTemplate_renderObject_fromResource_bundle_error
{
    GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
    context.stringProperty = @"foo";
    NSString *rendering = [GRMustacheTemplate renderObject:context
                                              fromResource:self.templateName
                                                    bundle:self.testBundle
                                                     error:NULL];
    STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
    STAssertEqualObjects(@"mustache", [self extensionOfTemplateFileInRendering:rendering], nil);
}

- (void)testGRMustacheTemplate_renderObject_fromResource_bundle_options_error
{
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                                  fromResource:self.templateName
                                                        bundle:self.testBundle
                                                       options:GRMustacheTemplateOptionNone
                                                         error:NULL];
        STAssertEquals(NO, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
        STAssertEqualObjects(@"mustache", [self extensionOfTemplateFileInRendering:rendering], nil);
    }
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.BOOLProperty = NO;
        context.boolProperty = NO;
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                                  fromResource:self.templateName
                                                        bundle:self.testBundle
                                                       options:GRMustacheTemplateOptionStrictBoolean
                                                         error:NULL];
        STAssertEquals(YES, [self valueForBOOLPropertyInRendering:rendering], nil);
        STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
        STAssertEqualObjects(@"mustache", [self extensionOfTemplateFileInRendering:rendering], nil);
    }
}

- (void)testGRMustacheTemplate_renderObject_fromResource_withExtension_bundle_error
{
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.stringProperty = @"foo";
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                                  fromResource:self.templateName
                                                 withExtension:@"json"
                                                        bundle:self.testBundle
                                                         error:NULL];
        STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
        STAssertEqualObjects(@"json", [self extensionOfTemplateFileInRendering:rendering], nil);
    }
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.stringProperty = @"foo";
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                                  fromResource:self.templateName
                                                 withExtension:@""
                                                        bundle:self.testBundle
                                                         error:NULL];
        STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
        STAssertEqualObjects(@"", [self extensionOfTemplateFileInRendering:rendering], nil);
    }
    {
        GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
        context.stringProperty = @"foo";
        NSString *rendering = [GRMustacheTemplate renderObject:context
                                                  fromResource:self.templateName
                                                 withExtension:nil
                                                        bundle:self.testBundle
                                                         error:NULL];
        STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
        STAssertEqualObjects(@"", [self extensionOfTemplateFileInRendering:rendering], nil);
    }
}

- (void)testGRMustacheTemplate_renderObject_fromResource_withExtension_bundle_options_error
{
    {
        {
            GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
            context.BOOLProperty = NO;
            context.boolProperty = NO;
            NSString *rendering = [GRMustacheTemplate renderObject:context
                                                      fromResource:self.templateName
                                                     withExtension:@"json"
                                                            bundle:self.testBundle
                                                           options:GRMustacheTemplateOptionNone
                                                             error:NULL];
            STAssertEquals(NO, [self valueForBOOLPropertyInRendering:rendering], nil);
            STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
            STAssertEqualObjects(@"json", [self extensionOfTemplateFileInRendering:rendering], nil);
        }
        {
            GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
            context.BOOLProperty = NO;
            context.boolProperty = NO;
            NSString *rendering = [GRMustacheTemplate renderObject:context
                                                      fromResource:self.templateName
                                                     withExtension:@""
                                                            bundle:self.testBundle
                                                           options:GRMustacheTemplateOptionNone
                                                             error:NULL];
            STAssertEquals(NO, [self valueForBOOLPropertyInRendering:rendering], nil);
            STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
            STAssertEqualObjects(@"", [self extensionOfTemplateFileInRendering:rendering], nil);
        }
        {
            GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
            context.BOOLProperty = NO;
            context.boolProperty = NO;
            NSString *rendering = [GRMustacheTemplate renderObject:context
                                                      fromResource:self.templateName
                                                     withExtension:nil
                                                            bundle:self.testBundle
                                                           options:GRMustacheTemplateOptionNone
                                                             error:NULL];
            STAssertEquals(NO, [self valueForBOOLPropertyInRendering:rendering], nil);
            STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
            STAssertEqualObjects(@"", [self extensionOfTemplateFileInRendering:rendering], nil);
        }
    }
    {
        {
            GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
            context.BOOLProperty = NO;
            context.boolProperty = NO;
            NSString *rendering = [GRMustacheTemplate renderObject:context
                                                      fromResource:self.templateName
                                                     withExtension:@"json"
                                                            bundle:self.testBundle
                                                           options:GRMustacheTemplateOptionStrictBoolean
                                                             error:NULL];
            STAssertEquals(YES, [self valueForBOOLPropertyInRendering:rendering], nil);
            STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
            STAssertEqualObjects(@"json", [self extensionOfTemplateFileInRendering:rendering], nil);
        }
        {
            GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
            context.BOOLProperty = NO;
            context.boolProperty = NO;
            NSString *rendering = [GRMustacheTemplate renderObject:context
                                                      fromResource:self.templateName
                                                     withExtension:@""
                                                            bundle:self.testBundle
                                                           options:GRMustacheTemplateOptionStrictBoolean
                                                             error:NULL];
            STAssertEquals(YES, [self valueForBOOLPropertyInRendering:rendering], nil);
            STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
            STAssertEqualObjects(@"", [self extensionOfTemplateFileInRendering:rendering], nil);
        }
        {
            GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
            context.BOOLProperty = NO;
            context.boolProperty = NO;
            NSString *rendering = [GRMustacheTemplate renderObject:context
                                                      fromResource:self.templateName
                                                     withExtension:nil
                                                            bundle:self.testBundle
                                                           options:GRMustacheTemplateOptionStrictBoolean
                                                             error:NULL];
            STAssertEquals(YES, [self valueForBOOLPropertyInRendering:rendering], nil);
            STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
            STAssertEqualObjects(@"", [self extensionOfTemplateFileInRendering:rendering], nil);
        }
    }
}

- (void)testGRMustacheTemplate_renderObject
{
    GRMustacheTemplate *template = [GRMustacheTemplate templateFromString:self.templateString error:NULL];
    GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
    context.stringProperty = @"foo";
    NSString *rendering = [template renderObject:context];
    STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
}

- (void)testGRMustacheTemplate_renderObjects
{
    GRMustacheTemplate *template = [GRMustacheTemplate templateFromString:self.templateString error:NULL];
    GRMustacheTemplateRenderMethodsTestSupport *context = [[[GRMustacheTemplateRenderMethodsTestSupport alloc] init] autorelease];
    context.stringProperty = @"foo";
    context.boolProperty = YES;
    NSDictionary *extraContext = [NSDictionary dictionaryWithObject:@"bar" forKey:@"stringProperty"];
    
    {
        NSString *rendering = [template renderObjects:context, extraContext, nil];
        STAssertEqualObjects(@"bar", [self valueForStringPropertyInRendering:rendering], nil);
        STAssertEquals(YES, [self valueForboolPropertyInRendering:rendering], nil);
    }
    {
        NSString *rendering = [template renderObjects:extraContext, context, nil];
        STAssertEqualObjects(@"foo", [self valueForStringPropertyInRendering:rendering], nil);
    }
}

- (void)testGRMustacheTemplate_render
{
    GRMustacheTemplate *template = [GRMustacheTemplate templateFromString:self.templateString error:NULL];
    NSString *rendering = [template render];
    STAssertEquals(NO, [self valueForboolPropertyInRendering:rendering], nil);
}

@end
