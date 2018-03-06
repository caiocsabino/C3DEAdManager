#import "C3DESponsorPayVirtualCurrenciesDelegate.h"

@implementation C3DESponsorPayVirtualCurrenciesDelegate

- (id)initWithCallback:(std::shared_ptr<C3DESponsorPayCallback::TypeVirtualCurrenciesCallback>)callback
{
    if (self = [super init])
    {
        m_callback = callback;
    }
    
    [SponsorPaySDK requestDeltaOfCoinsNotifyingDelegate:self];
    
    return self;
}

- (void)virtualCurrencyConnector:(SPVirtualCurrencyServerConnector *)connector
  didReceiveDeltaOfCoinsResponse:(double)deltaOfCoins
                      currencyId:(NSString *)currencyId
                    currencyName:(NSString *)currencyName
             latestTransactionId:(NSString *)transactionId
{
    NSLog(@"Returned delta of coins: %f for currency name: %@ and latest transaction ID: %@",
          deltaOfCoins, currencyName, transactionId);
    
    if (m_callback)
    {
        (*m_callback)(true, 0, "dummy", "dummy");
    }
    
    // Process the deltaOfCoins in the way that makes most sense for your application...
}

-(void)virtualCurrencyConnector:(SPVirtualCurrencyServerConnector *)vcConnector
                failedWithError:(SPVirtualCurrencyRequestErrorType)error
                      errorCode:(NSString *)errorCode
                   errorMessage:(NSString *)errorMessage
{
    // Handle the error in the way that makes most sense for your application...
    NSLog(@"Could not retrieve rewards");
    
    if (m_callback)
    {
        (*m_callback)(false, 0, "dummy", "dummy");
    }
}

@end