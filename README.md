

StarConsoleLink add the link to your console, which allows you to click on the link area rapid positioning to the log line

1.  Run StarConsoleLink in you Xcode

2.  If you are using Swift, Copy /StarConsoleLink/Plugin/Logger.swift in you project

3.  If you are using Objective-C, Copy below text in you PrefixHeader.pch

4.  If you want to custom you log, please follow the rules: [FileName.extension:LineNumber], Just like [main.swift:15]


#ifdef DEBUG
#define NSLog(format, ...) NSLog(@"[INFO][%@:%d] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(format), ##__VA_ARGS__])
#else
#define NSLog(...) while(0){}
#endif