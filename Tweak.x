#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// --- VRR CLIENT CONFIG ---
#define CLIENT_NAME @"VRR CLIENT v6 (MEGA)"
#define THEME_COLOR [UIColor colorWithRed:0.6 green:0.0 blue:0.8 alpha:1.0]

// --- FOUND INTERNAL NAMES ---
#define ITEM_BEANS @"Beans"
#define ITEM_GRENADE @"item_impulse_grenade"
#define ITEM_KEY_GRAVEYARD @"item_quest_key_graveyard"
#define ITEM_BOMB @"Bomb"
#define ITEM_BARREL @"Barrel"
#define EFFECT_VEHICLE_EXPLOSION @"Vehicle Explosion"
#define EFFECT_MACHINE_EXPLOSION @"ItemSellingMachineExplosion"

@interface VRRMenu : UIViewController
@property (nonatomic, strong) UIView *window;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic) BOOL godMode;
@property (nonatomic) BOOL spinBot;
@end

@implementation VRRMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.window = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 300, 500)];
    self.window.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.95];
    self.window.layer.borderColor = THEME_COLOR.CGColor;
    self.window.layer.borderWidth = 2.0;
    self.window.layer.cornerRadius = 12;
    [self.view addSubview:self.window];

    UILabel *head = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 45)];
    head.text = CLIENT_NAME;
    head.textColor = THEME_COLOR;
    head.textAlignment = NSTextAlignmentCenter;
    head.font = [UIFont systemFontOfSize:18 weight:UIFontWeightHeavy];
    head.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    [self.window addSubview:head];

    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 300, 455)];
    self.scroll.contentSize = CGSizeMake(300, 800);
    [self.window addSubview:self.scroll];

    [self addLabel:@"🛡️ PLAYER MODS" y:10];
    [self addSwitch:@"God Mode (Beans Loop)" y:40 action:@selector(toggleGod:)];
    [self addSwitch:@"Spin Bot (Fling)" y:80 action:@selector(toggleSpin:)];

    [self addLabel:@"🎒 ITEMS" y:130];
    [self addButton:@"Spawn Beans (Heal)" y:160 action:@selector(spawnBeans)];
    [self addButton:@"Spawn Graveyard Key" y:205 action:@selector(spawnKey)];
    [self addButton:@"Spawn Impulse Grenade" y:250 action:@selector(spawnGrenade)];

    [self addLabel:@"🧨 EXPLOSIVES" y:300];
    [self addButton:@"Spawn Bomb" y:330 action:@selector(spawnBomb)];
    [self addButton:@"Spawn Explosive Barrel" y:375 action:@selector(spawnBarrel)];
    
    [self addLabel:@"💥 EFFECTS" y:425];
    [self addButton:@"Spawn Vehicle Explosion" y:455 action:@selector(spawnVehExp)];
    [self addButton:@"Spawn Machine Explosion" y:500 action:@selector(spawnMachExp)];

    [self addButton:@"Force Close Menu" y:560 action:@selector(hideMenu)];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
    [self.window addGestureRecognizer:pan];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

- (void)gameLoop {
    static int timer = 0;
    if (self.godMode) {
        timer++;
        if (timer > 20) { [self spawnObject:ITEM_BEANS]; timer = 0; }
    }
}

- (void)spawnObject:(NSString *)itemName {
    // ⚠️ OFFSET REQUIRED HERE (Currently disabled to prevent crash)
    unsigned long long offset = 0x0; 
    if (offset == 0x0) return;
    
    // void (*Instantiate)(void*, float, float, float, void*) = (void*)(_dyld_get_image_header(0) + offset);
    // Instantiate(itemName, 0, 0, 0, NULL);
}

- (void)spawnBeans { [self spawnObject:ITEM_BEANS]; }
- (void)spawnKey { [self spawnObject:ITEM_KEY_GRAVEYARD]; }
- (void)spawnGrenade { [self spawnObject:ITEM_GRENADE]; }
- (void)spawnBomb { [self spawnObject:ITEM_BOMB]; }
- (void)spawnBarrel { [self spawnObject:ITEM_BARREL]; }
- (void)spawnVehExp { [self spawnObject:EFFECT_VEHICLE_EXPLOSION]; }
- (void)spawnMachExp { [self spawnObject:EFFECT_MACHINE_EXPLOSION]; }
- (void)toggleGod:(UISwitch *)s { self.godMode = s.isOn; }
- (void)toggleSpin:(UISwitch *)s { self.spinBot = s.isOn; }
- (void)hideMenu { [self.window removeFromSuperview]; }

- (void)addLabel:(NSString *)t y:(CGFloat)y {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 200, 20)];
    l.text = t; l.textColor = [UIColor lightGrayColor]; l.font = [UIFont boldSystemFontOfSize:12];
    [self.scroll addSubview:l];
}
- (void)addSwitch:(NSString *)t y:(CGFloat)y action:(SEL)a {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 180, 30)];
    l.text = t; l.textColor = [UIColor whiteColor]; [self.scroll addSubview:l];
    UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(230, y, 50, 30)];
    [s addTarget:self action:a forControlEvents:UIControlEventValueChanged];
    s.onTintColor = THEME_COLOR; [self.scroll addSubview:s];
}
- (void)addButton:(NSString *)t y:(CGFloat)y action:(SEL)a {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(15, y, 270, 35);
    [b setTitle:t forState:UIControlStateNormal];
    b.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    b.tintColor = [UIColor whiteColor]; b.layer.cornerRadius = 8;
    [b addTarget:self action:a forControlEvents:UIControlEventTouchUpInside];
    [self.scroll addSubview:b];
}
- (void)drag:(UIPanGestureRecognizer *)p {
    UIView *v = p.view; CGPoint t = [p translationInView:self.view];
    v.center = CGPointMake(v.center.x + t.x, v.center.y + t.y);
    [p setTranslation:CGPointZero inView:self.view];
}

@end

static void appLoad(CFNotificationCenterRef c, void *o, CFStringRef n, const void *obj, CFDictionaryRef u) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        VRRMenu *m = [[VRRMenu alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:m.view];
    });
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &appLoad, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
