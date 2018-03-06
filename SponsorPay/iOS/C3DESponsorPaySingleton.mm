#import "C3DESponsorPaySingleton.h"

@implementation C3DESponsorPaySingleton

@synthesize m_responseDelegate;

#pragma mark Singleton Methods

+ (id)sharedManager
{
    static C3DESponsorPaySingleton *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)requestDeltaOfCoins:(std::shared_ptr<C3DESponsorPayCallback::TypeVirtualCurrenciesCallback>)callback
{
    m_virtualCurrenciesDelegate = [[C3DESponsorPayVirtualCurrenciesDelegate alloc] initWithCallback:callback];
}

- (void)requestVideoOffers:(std::shared_ptr<C3DESponsorPayCallback::TypeVideoOfferCallback>)callback
{
    m_lastVideoOfferCallback = callback;
    
    //m_videoOfferDelegate = [[C3DESponsorPayVideoOfferDelegate alloc] initWithCallback:callback];
    [SponsorPaySDK requestBrandEngageOffersNotifyingDelegate:self];
}

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
         didReceiveOffers:(BOOL)areOffersAvailable;
{
    m_lastEngageClient = brandEngageClient;
    
    m_lastEngageClient.shouldShowRewardNotificationOnEngagementCompleted = NO;
    
    if (!areOffersAvailable)
    {
        m_lastEngageClient = nil;
    }
    
    if (m_lastVideoOfferCallback)
    {
        (*m_lastVideoOfferCallback)(true, areOffersAvailable);
    }
    
    
}


- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
          didChangeStatus:(SPBrandEngageClientStatus)newStatus
{
    if (m_lastVideoFinishedCallback && newStatus != STARTED && newStatus != ERROR)
    {
        bool completed = newStatus == CLOSE_FINISHED;
        
        (*m_lastVideoFinishedCallback)(true, completed);
    }
    
    if (m_lastVideoOfferCallback && newStatus == ERROR)
    {
        m_lastEngageClient = nil;
        (*m_lastVideoOfferCallback)(false, false);
    }
    
}

- (void)playOfferedVideo:(UIViewController *) rootViewController
                callback:(std::shared_ptr<C3DESponsorPayCallback::TypeVideoFinishedCallback>) callback
{
    if (m_lastEngageClient)
    {
        m_lastEngageClient.shouldShowRewardNotificationOnEngagementCompleted = NO;
        m_lastVideoFinishedCallback = callback;
        [m_lastEngageClient startWithParentViewController:rootViewController];
        
        m_lastEngageClient = nil;
    }
}

- (bool)hasVideoOffer
{
    return m_lastEngageClient != nil;
}

- (void)dealloc
{
    // Should never be called, but just here for clarity really.
}

@end