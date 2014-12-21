//
//  SecondViewController.m
//  OIS-dn4
//
//  Created by Klemen Kosir on 11. 12. 14.
//  Copyright (c) 2014 Lonely Cappuccino. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController ()

@end

@implementation SecondViewController {
    HKHealthStore *health;
    NSString *sessionID;
    NSString *height, *weight, *temp, *pressSys, *pressDia, *heartRate, *oxySat, *steps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    sessionID = nil;
    [_ehrIdField setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"ehrIdSaved"]];
    NSLog(@"EhrId: %@",_ehrIdField.text);
   if ([HKHealthStore isHealthDataAvailable]) {
       [self loadHealthKit];
   }
    //[self postSteps];
    //[self getSessionID];
}

-(void)loadHealthKit {
    health = [[HKHealthStore alloc]init];
    NSSet *types = [NSSet setWithObject:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]];
    
    types = [NSSet setWithObjects:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic],[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate], nil];
    
    [health requestAuthorizationToShareTypes:nil readTypes:types completion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"success!");
            
        }
    }];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    if (_stepsSwitch.on) {
        HKSampleQuery *querySteps = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS Steps: %@",results);
            [self sumSteps:results];
        }];
        [health executeQuery:querySteps];
    }
    
    if (_oxySatSwitch.on) {
        HKSampleQuery *queryOxySat = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierOxygenSaturation] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS OxySat: %@",results);
            HKQuantitySample *sample = [results lastObject];
            oxySat = [NSString stringWithFormat:@"%.2f",[[sample quantity]doubleValueForUnit:[HKUnit percentUnit]]*100];
            NSLog(@"RESULTS OxySat: %@",oxySat);
        }];
        [health executeQuery:queryOxySat];
    }
    
    if (_heightSwitch.on) {
        HKSampleQuery *queryHeight = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS Height: %@",results);
            HKQuantitySample *sample = [results lastObject];
            height = [NSString stringWithFormat:@"%.2f",[[sample quantity]doubleValueForUnit:[HKUnit meterUnitWithMetricPrefix:HKMetricPrefixCenti]]];
            NSLog(@"RESULTS Height: %@",height);
        }];
        [health executeQuery:queryHeight];
    }
    
    if (_weightSwitch.on) {
        HKSampleQuery *queryWeight = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS Weight: %@",results);
            HKQuantitySample *sample = [results lastObject];
            weight = [NSString stringWithFormat:@"%.2f",[[sample quantity]doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo]]];
            NSLog(@"RESULTS Weight: %@",weight);
        }];
        [health executeQuery:queryWeight];
    }
    
    if (_tempSwitch.on) {
        HKSampleQuery *queryTemp = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS Temp: %@",results);
            HKQuantitySample *sample = [results lastObject];
            temp = [NSString stringWithFormat:@"%.2f",[[sample quantity]doubleValueForUnit:[HKUnit degreeCelsiusUnit]]];
            NSLog(@"RESULTS Temp: %@",temp);
        }];
        [health executeQuery:queryTemp];
    }
    
    if (_pressSysSwitch.on) {
        HKSampleQuery *queryPressSys = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS PressSys: %@",results);
            HKQuantitySample *sample = [results lastObject];
            pressSys = [NSString stringWithFormat:@"%.2f",[[sample quantity]doubleValueForUnit:[HKUnit millimeterOfMercuryUnit]]];
            NSLog(@"RESULTS PressSys: %@",pressSys);
        }];
        [health executeQuery:queryPressSys];
    }
    
    if (_pressDiaSwitch.on) {
        HKSampleQuery *queryPressDia = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS PressDia: %@",results);
            HKQuantitySample *sample = [results lastObject];
            pressDia = [NSString stringWithFormat:@"%.2f",[[sample quantity]doubleValueForUnit:[HKUnit millimeterOfMercuryUnit]]];
            NSLog(@"RESULTS PressDia: %@",pressDia);
        }];
        [health executeQuery:queryPressDia];
    }
    
    if (_heartRateSwitch.on) {
        HKSampleQuery *queryPressDia = [[HKSampleQuery alloc]initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate] predicate:predicate limit:0 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            //NSLog(@"RESULTS HeartRate: %@",results);
            HKQuantitySample *sample = [results lastObject];
            heartRate = [NSString stringWithFormat:@"%d",(int)([[sample quantity]doubleValueForUnit:[HKUnit unitFromString:@"count/s"]]*60)];
            NSLog(@"RESULTS HeartRate: %@",heartRate);
        }];
        [health executeQuery:queryPressDia];
    }
    
    [self getSessionID];
}

-(void)sumSteps:(NSArray*)results {
    int numOfSteps = 0;
    for (HKQuantitySample *sample in results) {
        numOfSteps += (int)[[sample quantity]doubleValueForUnit:[HKUnit unitFromString:@"count"]];
    }
    NSLog(@"Steps: %d",numOfSteps);
    steps = [NSString stringWithFormat:@"%d",numOfSteps];
}

-(void)getSessionID {
    
    NSString *urlString = [NSString stringWithFormat:@"https://rest.ehrscape.com/rest/v1/session?username=%@&password=%@",@"ois.seminar",@"ois4fri"];
    NSLog(@"string: %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url: %@",url);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    //NSLog(@"con: %@",connection);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"response: %@",response);
    int statusCode = (int)[(NSHTTPURLResponse*)response statusCode];
    NSDictionary *responseDict = [(NSHTTPURLResponse*)response allHeaderFields];
    if ([responseDict objectForKey:@"Ehr-Session"] && sessionID == nil) {
        sessionID = [responseDict objectForKey:@"Ehr-Session"];
        NSLog(@"sessionID: %@",sessionID);
        [_button setEnabled:YES];
        //[self postData];
    }
    else {
        if (statusCode == 201) {
            [_infoLabel setText:@"Uspešno!"];
        }
        else {
            [_infoLabel setText:[NSString stringWithFormat:@"Napaka %d",statusCode]];
        }
    }
}

-(void)postData {
    NSLog(@"POST DATA");
    NSString *ehrId = _ehrIdField.text;
    NSString *urlString = [NSString stringWithFormat:@"https://rest.ehrscape.com/rest/v1/composition?ehrId=%@&templateId=%@&format=FLAT&committer=Franja",ehrId,@"Vital%20Signs"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"URL: %@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:sessionID forHTTPHeaderField:@"Ehr-Session"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd;HH:mm:ss"];
    NSString *currentDate = [dateFormater stringFromDate:[NSDate date]];
    currentDate = [currentDate stringByReplacingOccurrencesOfString:@";" withString:@"T"];
    NSLog(@"DATE: %@",currentDate);
    NSMutableDictionary *podatkiDict = [NSMutableDictionary dictionary];
    [podatkiDict setObject:@"en" forKey:@"ctx/language"];
    [podatkiDict setObject:@"SI" forKey:@"ctx/territory"];
    [podatkiDict setObject:currentDate forKey:@"ctx/time"];
    [podatkiDict setObject:height forKey:@"vital_signs/height_length/any_event/body_height_length"];
    [podatkiDict setObject:weight forKey:@"vital_signs/body_weight/any_event/body_weight"];
    [podatkiDict setObject:temp forKey:@"vital_signs/body_temperature/any_event/temperature|magnitude"];
    [podatkiDict setObject:@"°C" forKey:@"vital_signs/body_temperature/any_event/temperature|unit"];
    [podatkiDict setObject:pressSys forKey:@"vital_signs/blood_pressure/any_event/systolic"];
    [podatkiDict setObject:pressDia forKey:@"vital_signs/blood_pressure/any_event/diastolic"];
    [podatkiDict setObject:oxySat forKey:@"vital_signs/indirect_oximetry:0/spo2|numerator"];
    [podatkiDict setObject:heartRate forKey:@"vital_signs/pulse:0/any_event:0/rate|magnitude:pulse"];
    
    NSData *podatki = [NSJSONSerialization dataWithJSONObject:podatkiDict options:0 error:nil];
    
    //[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[podatki length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:podatki];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    //NSLog(@"Connection: %@",connection);
    NSLog(@"...end");
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"Error: %@",error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonAction:(id)sender {
    [self postData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_ehrIdField.isFirstResponder) {
        [_ehrIdField resignFirstResponder];
        [[NSUserDefaults standardUserDefaults]setObject:_ehrIdField.text forKey:@"ehrIdSaved"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
     
@end
