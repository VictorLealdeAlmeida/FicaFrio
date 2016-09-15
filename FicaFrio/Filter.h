//
//  Filter.h
//  FicaFrio
//
//  Created by Diana Monteiro on 15/09/16.
//  Copyright 2010 CMG Research. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NZEROS 10
#define NPOLES 10

@interface Filter : NSObject {
    float xv[NZEROS+1], yv[NPOLES+1];
}

-(float) processValue:(float) value;

@end
