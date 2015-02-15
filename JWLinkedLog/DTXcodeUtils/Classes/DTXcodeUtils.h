
@class DVTSourceTextView;
@class DVTTextStorage;
@class IDEEditor;
@class IDESourceCodeEditor;
@class IDEEditorArea;
@class IDESourceCodeDocument;
@class IDEEditorContext;
@class IDEWorkspaceWindowController;

@interface DTXcodeUtils : NSObject
+ (NSWindow *)currentWindow;
+ (NSResponder *)currentWindowResponder;
+ (NSMenu *)mainMenu;
+ (IDEWorkspaceWindowController *)currentWorkspaceWindowController;
+ (IDEEditorArea *)currentEditorArea;
+ (IDEEditorContext *)currentEditorContext;
+ (IDEEditor *)currentEditor;
+ (IDESourceCodeEditor *)currentSourceCodeEditor;
+ (IDESourceCodeDocument *)currentSourceCodeDocument;
+ (DVTSourceTextView *)currentSourceTextView;
+ (DVTTextStorage *)currentTextStorage;
+ (NSScrollView *)currentScrollView;

+ (NSMenuItem *)getMainMenuItemWithTitle:(NSString *)title;
@end
