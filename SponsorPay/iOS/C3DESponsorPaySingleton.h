#ifndef C3DE_SPONSOR_PAY_SINGLETON_H
#define C3DE_SPONSOR_PAY_SINGLETON_H

#include "C3DESponsorPayCallback.h"

#import "SponsorPaySDK.h"
#import "SPVirtualCurrencyServerConnector.h"

#import "SponsorPaySDK.h"
#import "SPVirtualCurrencyServerConnector.h"
#import "SPVirtualCurrencyConnectionDelegate.h"
#import <Foundation/Foundation.h>

#import "C3DESponsorPayVirtualCurrenciesDelegate.h"
#import "C3DESponsorPayVideoOfferDelegate.h"


#include <memory.h>

@interface C3DESponsorPaySingleton : NSObject<SPBrandEngageClientDelegate>
{
    C3DESponsorPayVirtualCurrenciesDelegate *m_virtualCurrenciesDelegate;
    //C3DESponsorPayVideoOfferDelegate *m_videoOfferDelegate;
    
    SPBrandEngageClient * m_lastEngageClient;
    
    std::shared_ptr<C3DESponsorPayCallback::TypeVideoOfferCallback> m_lastVideoOfferCallback;
    std::shared_ptr<C3DESponsorPayCallback::TypeVideoFinishedCallback> m_lastVideoFinishedCallback;

}

@property (nonatomic, retain) C3DESponsorPayVirtualCurrenciesDelegate *m_responseDelegate;
@property (nonatomic, retain) SPBrandEngageClient *m_lastEngageClient;

+ (id)sharedManager;

- (void)requestDeltaOfCoins:(std::shared_ptr<C3DESponsorPayCallback::TypeVirtualCurrenciesCallback>)callback;

- (void)requestVideoOffers:(std::shared_ptr<C3DESponsorPayCallback::TypeVideoOfferCallback>)callback;

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
         didReceiveOffers:(BOOL)areOffersAvailable;

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
          didChangeStatus:(SPBrandEngageClientStatus)newStatus;

- (void)playOfferedVideo:(UIViewController *) rootViewController
                callback:(std::shared_ptr<C3DESponsorPayCallback::TypeVideoFinishedCallback>) callback;

- (bool)hasVideoOffer;

@end

#endif