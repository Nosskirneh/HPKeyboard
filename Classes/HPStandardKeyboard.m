//
//  HPStandardKeyboard.m
//  HPKeyboard
//
//  Created by Huy Pham on 1/17/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

#define KeyboardRecentTagsPlist @"HPKeyboardRecentTags.plist"

#import "HPStandardKeyboard.h"
#import "HPKeyboardCollection.h"
#import "HPKeyboardCollectionItem.h"
#import "EmojiHelper.h"

@implementation HPStandardKeyboard

+ (HPKeyboard *)sharedKeyboard {
    
    static dispatch_once_t once;
    static id sharedKeyboard;
    dispatch_once(&once, ^{
        sharedKeyboard = [HPKeyboard keyboard];
        [self initKeyboard:sharedKeyboard];
        
    });
    return sharedKeyboard;
}

+ (void)initKeyboard:(HPKeyboard *)keyboard {
    NSArray<EmojiCategory *> *allCategories = [EmojiHelper getAllEmojisInCategories];

    NSMutableArray *collections = [NSMutableArray new];
    HPKeyboardCollection *collection;

    collection = [self keyboardCollectionFromStringArray:[EmojiHelper getRecentlyUsedEmojis]];
    [collection.title setText:@"Recently used"];
    [collection.pageControl setHidden:YES];
    [collection.barButton setImage:[UIImage imageNamed:@"HPKeyboardRecent"] forState:UIControlStateNormal];
    [collection.barButton setImage:[UIImage imageNamed:@"HPKeyboardRecentSelected"] forState:UIControlStateSelected];
    [collections addObject:collection];

    for (EmojiCategory *category in allCategories) {
        collection = [self keyboardCollectionFromEmojiArray:category.emoji];
        // Map the image names
        NSString *imageName = nil;
        if ([category.id hasSuffix:@"People"])
            imageName = @"HPKeyboardSmile";
        else if ([category.id hasSuffix:@"Nature"])
            imageName = @"HPKeyboardNature";
        else if ([category.id hasSuffix:@"FoodAndDrink"])
            imageName = @"HPKeyboardFood";
        else if ([category.id hasSuffix:@"Activity"])
            imageName = @"HPKeyboardActivity";
        else if ([category.id hasSuffix:@"Celebration"])
            imageName = @"HPKeyboardCelebration";
        else if ([category.id hasSuffix:@"TravelAndPlaces"])
            imageName = @"HPKeyboardTravel";
        else if ([category.id hasSuffix:@"Symbols"])
            imageName = @"HPKeyboardSymbols";
        else if ([category.id hasSuffix:@"Objects"])
            imageName = @"HPKeyboardObjects";
        else if ([category.id hasSuffix:@"Flags"])
            imageName = @"HPKeyboardFlags";

        if (imageName) {
            [collection.barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [collection.barButton setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"Selected"]] forState:UIControlStateSelected];
        }
        [collections addObject:collection];
    }

    [keyboard setKeyBoardCollections:collections];
}

+ (HPKeyboardCollection *)keyboardCollectionFromEmojiArray:(NSArray<Emoji *> *)array {
    HPKeyboardCollection *collection = [[HPKeyboardCollection alloc] init];
    if (array) {
        NSMutableArray *items = [NSMutableArray array];
        for (Emoji *emoji in array) {
            HPKeyboardCollectionItem *item = [[HPKeyboardCollectionItem alloc] init];
            [item setTitle:emoji.emojiString];
            [item setCharacter:emoji.emojiString];
            [items addObject:item];
        }
        [collection setKeyItems:items];
    } else {
        [collection setKeyItems:[NSMutableArray array]];
    }
    return collection;
}

+ (HPKeyboardCollection *)keyboardCollectionFromStringArray:(NSArray<NSString *> *)array {
    HPKeyboardCollection *collection = [[HPKeyboardCollection alloc] init];
    if (array) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSString *emoji in array) {
            HPKeyboardCollectionItem *item = [[HPKeyboardCollectionItem alloc] init];
            [item setTitle:emoji];
            [item setCharacter:emoji];
            [items addObject:item];
        }
        [collection setKeyItems:items];
    } else {
        [collection setKeyItems:[NSMutableArray array]];
    }
    return collection;
}

@end
