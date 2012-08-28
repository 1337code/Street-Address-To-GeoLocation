//
//  main.m
//  Street-Address-To-GeoLocation
//
//  Created by Vedran Burojevic on 8/28/12.
//  Copyright (c) 2012 Vedran Burojevic. All rights reserved.
//

#import <Foundation/Foundation.h>

int main (int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        // This is a list of some banks in Zagreb, with their name and address
        // Code will find longitude and latitude of the given address with help of Google Maps
        
        [list addObject:@"ERSTE - bankomat -  Hrgovići 55 ,Hrgovići 55 "];
        [list addObject:@"ERSTE - bankomat -  Kranjčevićeva 29 ,Kranjčevićeva 29 "];
        [list addObject:@"ERSTE - bankomat - Alberta Fortisa 16,Alberta Fortisa 16"];
        [list addObject:@"HYPO - bankomat - Roto Stenjevac,Stenjevac 1 "];
        [list addObject:@"HYPO - bankomat - Slavonska avenija 6,Slavonska avenija 6"];
        [list addObject:@"Hypo - bankomat - Škorpikova 34 ,Škorpikova 34 "];
        [list addObject:@"HYPO - bankomat - Trakošćanska 5,Trakošćanska 5"];
        [list addObject:@"HYPO - bankomat - Trg bana Josipa Jelačića 3 ,Trg bana Josipa Jelačića 3 "];
        [list addObject:@"PBZ - bankomat - Tržnica Vrapče,Tržnica Vrapče"];
        [list addObject:@"PBZ - bankomat - Ulica Grada Vukovara 271 ,Ulica Grada Vukovara 271 "];
        [list addObject:@"PBZ - bankomat - Ulica Grada Vukovara 72 ,Ulica Grada Vukovara 72 "];
        [list addObject:@"PBZ - bankomat - V. Mačeka 15,V. Mačeka 15"];
        [list addObject:@"PBZ - bankomat - V. Varičaka 32,V. Varičaka 32"];
        [list addObject:@"PBZ - bankomat - Vilka Šefera 2 ,Vilka Šefera 2 "];
        [list addObject:@"PBZ - bankomat - Vlaška 39,Vlaška 39"];
        [list addObject:@"PBZ - bankomat - Volovčica bb,Volovčica bb"];
        [list addObject:@"PBZ - bankomat - Zavrtnica 17,Zavrtnica 17"];
        [list addObject:@"PBZ - bankomat - Zgrebačka 12,Zgrebačka 12"];
        [list addObject:@"ZAGREBACKA BANKA d.d.,Kobiljacka cesta 102"];
        [list addObject:@"ZAGREBACKA BANKA d.d.,Kralja Tomislava 2"];
        [list addObject:@"ZAGREBACKA BANKA d.d.,Trg Ante Starčevića 2"];
        [list addObject:@"ZAGREBACKA BANKA d.d.,ZAGREBACKA 148"];
        [list addObject:@"ZAGREBACKA BANKA d.d.,ZAGREBACKA 4"];
        
        int counter = 0;
        
        for (int i=0; i<[list count]; i++) {
            
            NSArray *seperatedTextByNewLine = [[list objectAtIndex:i] componentsSeparatedByString:@","];
            
            NSString *name = [seperatedTextByNewLine objectAtIndex:0];
            NSString *address = [seperatedTextByNewLine objectAtIndex:1];
            
            address = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            
            //NSLog(@"%@", address);
            
            NSString *urlString;
            NSString *locationString;
            NSArray *listItems;
            
            // Change Zagreb to the city of where the address is located
            // Change Hrvatska to name of your Country
            
            urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@,+Zagreb,+Hrvatska&output=csv&hl=en&ie=UTF8", [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
            
            listItems = [locationString componentsSeparatedByString:@","];
            
            // Change the filePath tou your desired location where you want to save the results
            
            NSString *filePath = @"/Users/vedranburojevic/Desktop/bankomati.txt";
            
            NSString *text = [NSString stringWithFormat:@"%@ : %@, %@\n", name, [listItems objectAtIndex:2], [listItems objectAtIndex:3]];
            
            NSLog(@"Added %@ - %@, %@\n", name, [listItems objectAtIndex:2], [listItems objectAtIndex:3]);
            counter++;
            NSLog(@"%d/%lu", counter, [list count]);
            
            // NSFileHandle won't create the file for us, so we need to check to make sure it exists
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                
                // the file doesn't exist yet, so we can just write out the text using the
                // NSString convenience method
                
                NSError *error = noErr;
                BOOL success = [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                if (!success) {
                    // handle the error
                    NSLog(@"%@", error);
                }
                
            } else {
                
                // the file already exists, so we should append the text to the end
                
                // get a handle to the file
                NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
                
                // move to the end of the file
                [fileHandle seekToEndOfFile];
                
                // convert the string to an NSData object
                NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];
                
                // write the data to the end of the file
                [fileHandle writeData:textData];
                
                // clean up
                [fileHandle closeFile];
            }
            // Required pause because Google server can't handle so many requests at once
            [NSThread sleepForTimeInterval:1.0f];
        }
    }
    return 0;
}
