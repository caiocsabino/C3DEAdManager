#ifndef SPONSOR_PAY_VIDEO_OFFER_DELEGATE_H
#define SPONSOR_PAY_VIDEO_OFFER_DELEGATE_H

#include "C3DESponsorPayCallback.h"

#import "SponsorPaySDK.h"
#import "SPVirtualCurrencyServerConnector.h"

#import "SponsorPaySDK.h"
#import "SPVirtualCurrencyServerConnector.h"
#import "SPBrandEngageClientDelegate.h"
#import <Foundation/Foundation.h>

#include <memory.h>

@interface C3DESponsorPayVideoOfferDelegate : NSObject<SPBrandEngageClientDelegate>
{
    std::shared_ptr<C3DESponsorPayCallback::TypeVideoOfferCallback> m_callback;
}

- (id)initWithCallback:(std::shared_ptr<C3DESponsorPayCallback::TypeVideoOfferCallback>)callback;

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient
         didReceiveOffers:(BOOL)areOffersAvailable;

- (void)brandEngageClient:(id)brandEngageClient
          didChangeStatus:(id)newStatus;

@end

#endif