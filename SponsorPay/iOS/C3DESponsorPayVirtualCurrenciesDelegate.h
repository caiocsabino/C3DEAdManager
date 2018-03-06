#ifndef SPONSOR_PAY_VIRTUAL_CURRENCIES_DELEGATE_H
#define SPONSOR_PAY_VIRTUAL_CURRENCIES_DELEGATE_H

#include "C3DESponsorPayCallback.h"

#import "SponsorPaySDK.h"
#import "SPVirtualCurrencyServerConnector.h"

#import "SponsorPaySDK.h"
#import "SPVirtualCurrencyServerConnector.h"
#import "SPVirtualCurrencyConnectionDelegate.h"
#import <Foundation/Foundation.h>

#include <memory.h>

@interface C3DESponsorPayVirtualCurrenciesDelegate : NSObject<SPVirtualCurrencyConnectionDelegate>
{
    std::shared_ptr<C3DESponsorPayCallback::TypeVirtualCurrenciesCallback> m_callback;
}

- (id)initWithCallback:(std::shared_ptr<C3DESponsorPayCallback::TypeVirtualCurrenciesCallback>)callback;

- (void)virtualCurrencyConnector:(SPVirtualCurrencyServerConnector *)connector
  didReceiveDeltaOfCoinsResponse:(double)deltaOfCoins
                      currencyId:(NSString *)currencyId
                    currencyName:(NSString *)currencyName
             latestTransactionId:(NSString *)transactionId;


- (void)virtualCurrencyConnector:(SPVirtualCurrencyServerConnector *)connector failedWithError:(SPVirtualCurrencyRequestErrorType)error errorCode:(NSString *)errorCode errorMessage:(NSString *)errorMessage;

@end

#endif