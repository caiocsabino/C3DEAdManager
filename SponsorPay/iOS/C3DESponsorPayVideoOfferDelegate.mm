#import "C3DESponsorPayVideoOfferDelegate.h"

@implementation C3DESponsorPayVideoOfferDelegate

- (id)initWithCallback:(std::shared_ptr<C3DESponsorPayCallback::TypeVideoOfferCallback>)callback
{
    if (self = [super init])
    {
        m_callback = callback;
    }
    
    [SponsorPaySDK requestBrandEngageOffersNotifyingDelegate:self];
    
    return self;
}

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
         didReceiveOffers:(BOOL)areOffersAvailable
{
    
    NSLog(@"Returned video offers");
    
    if (m_callback)
    {
        (*m_callback)(true, areOffersAvailable);
    }
    
}

- (void)brandEngageClient:(id)brandEngageClient
          didChangeStatus:(id)newStatus
{
    
}

@end