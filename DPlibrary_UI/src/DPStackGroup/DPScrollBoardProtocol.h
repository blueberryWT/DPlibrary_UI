//
// Created by BlueBerry on 13-2-6.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol DPScrollBoardProtocol <NSObject>

// [yu] 页面将要消失时会调用这个函数
-(void) dpBoardWillDisappearDisplay:(id) object;

// [yu] 页面将要显示的时候调用这个函数
-(void) dpBoardWillAppearDisplay:(id) object;

@end