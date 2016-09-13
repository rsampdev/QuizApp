//
//  ViewController.m
//  Quiz
//
//  Created by Rodney Sampson on 9/9/16.
//  Copyright © 2016 Rodney Sampson II. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) IBOutlet UILabel *currentQuestionLabel;
@property (nonatomic) IBOutlet UILabel *nextQuestionLabel;
@property (nonatomic) IBOutlet UILabel *answerLabel;
@property (nonatomic) IBOutlet NSLayoutConstraint *currentQuestionLabelCenterXConstraint;
@property (nonatomic) IBOutlet NSLayoutConstraint *nextQuestionLabelCenterXConstraint;
@property (nonatomic) NSArray *questions;
@property (nonatomic) NSArray *answers;
@property (nonatomic) int currentQuestionIndex;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.questions = @[ @"What is your name?", @"What is your quest?", @"What is your favorite color?" ];
    self.answers = @[ @"Sir Galahad of Camelot", @"I seek the Grail", @"Blue. No, yel-" ];
    self.currentQuestionLabel.text = self.questions[self.currentQuestionIndex];
    [self updateOffScreenLabel];
}

- (void)updateOffScreenLabel {
    CGFloat screenWidth = self.view.frame.size.width;
    self.nextQuestionLabelCenterXConstraint.constant = -screenWidth;
    self.nextQuestionLabel.alpha = 0.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nextQuestionLabel.alpha = 0.0;
}

- (IBAction)showNextQuestion:(id)sender {
    self.currentQuestionIndex++;
    if (self.currentQuestionIndex == self.questions.count) {
        self.currentQuestionIndex = 0;
    }
    NSString *question = self.questions[self.currentQuestionIndex];
    self.nextQuestionLabel.text = question;
    self.answerLabel.text = @"???";
    
    [self animateLabelTransitions];
}

- (IBAction)showAnswer:(id)sender {
    NSString *answer = self.answers[self.currentQuestionIndex];
    self.answerLabel.text = answer;
}

- (void)animateLabelTransitions {
    [self.view layoutIfNeeded];
    CGFloat screenWidth = self.view.frame.size.width;
    self.nextQuestionLabelCenterXConstraint.constant = 0;
    self.currentQuestionLabelCenterXConstraint.constant += screenWidth;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.currentQuestionLabel.alpha = 0.0;
                         self.nextQuestionLabel.alpha = 1.0;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         UILabel *tempLabel = self.currentQuestionLabel;
                         self.currentQuestionLabel = self.nextQuestionLabel;
                         self.nextQuestionLabel = tempLabel;
                         NSLayoutConstraint *tempConstraint = self.currentQuestionLabelCenterXConstraint;
                         self.currentQuestionLabelCenterXConstraint = self.nextQuestionLabelCenterXConstraint;
                         self.nextQuestionLabelCenterXConstraint = tempConstraint;
                         [self updateOffScreenLabel];
                     }];
}

@end
