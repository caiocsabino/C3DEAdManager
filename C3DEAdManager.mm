#include "C3DEAdManager.h"
#include <algorithm>

#include "C3DEConsole.h"
#include <memory>

#if defined(PLATFORM_IPHONE)
#ifdef ADS_SPONSOR_PAY

#include "C3DEWrapper.h"
#import "SponsorPaySDK.h"
#import "SPVirtualCurrencyServerConnector.h"
#import "SPVirtualCurrencyConnectionDelegate.h"
#import <Foundation/Foundation.h>
#import "C3DESponsorPaySingleton.h"
#endif
#elif defined(PLATFORM_ANDROID)
#include "C3DESystemManager.h"
#endif

#include "C3DEThread.h"

#include "DebugMemory.h"

C3DEAdManager::C3DEAdManager()
    : m_showingAd(false)
	, m_offersInitializationRequested(false)
	, m_fakeVideoOfferRequested(false)
    , m_usingFakeAds(false)
    , m_applicationID("")
    , m_userID("")
    , m_securityToken("")
{

}

C3DEAdManager::~C3DEAdManager()
{
    
}

bool C3DEAdManager::InitializeAdOfferings(const std::string& appID, const std::string& appSecret, const std::string& userID, int arguments)
{
	m_offersInitializationRequested = true;

    if (m_usingFakeAds)
    {
        return true;
    }

#if defined(PLATFORM_IPHONE)
#if defined(ADS_SPONSOR_PAY)

    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    
    m_applicationID = appID;
    m_securityToken = appSecret;
    
    NSString *applicationIDStr = [NSString stringWithUTF8String:appID.c_str()];
    NSString *securityTokenStr = [NSString stringWithUTF8String:appSecret.c_str()];
    
    m_userID = userID;

    if (userID.empty())
    {
        NSString *userID = [SponsorPaySDK startWithAutogeneratedUserForAppId:applicationIDStr securityToken:securityTokenStr];
            
        m_userID = [userID UTF8String];
    }
    else
    {
        NSString *userIDStr = [NSString stringWithUTF8String:userID.c_str()];
        [SponsorPaySDK startForAppId:applicationIDStr userId:userIDStr securityToken:securityTokenStr];
        [SponsorPaySDK setShowPayoffNotificationOnVirtualCoinsReceived:false];
    }
    
    m_initialized = true;
    
    return true;
#else // ifdef ADS_SPONSOR_PAY
    return false;
#endif
    
#elif defined(PLATFORM_ANDROID)
#if defined(ADS_SPONSOR_PAY)
    C3DESystemManager::GetInstance()->GetAndroidEngine()->InitializeSponsorPay(applicationID, securityToken);
    
    m_initialized = true;
    
    return true;
#elif defined(ADS_APPODEAL)
    
    C3DESystemManager::GetInstance()->GetAndroidEngine()->InitializeAppodeal(appSecret, arguments);
    
    m_initialized = true;
    
    return true;
    
#endif // ifdef ADS_SPONSOR_PAY
    
#endif // elif defined(PLATFORM_ANDROID)
    
return false;

}

bool C3DEAdManager::HasRewardedVideo() const
{
    if (m_usingFakeAds)
    {
        return m_fakeVideoOfferRequested;
    }
    
    
#if defined(PLATFORM_IPHONE)
#if defined(ADS_SPONSOR_PAY)
    C3DESponsorPaySingleton *sharedManager = [C3DESponsorPaySingleton sharedManager];
    return [sharedManager hasVideoOffer];
#else // #ifdef ADS_SPONSOR_PAY
    return false;
#endif
#elif defined(PLATFORM_ANDROID)
#if defined(ADS_APPODEAL)
    return true;
#else
    return false;
#endif
#endif // if defined(PLATFORM_IPHONE)

}

bool C3DEAdManager::GetIsAdOfferInitialized() const
{
    if (m_usingFakeAds)
    {
        return m_offersInitializationRequested;    
    }

    return m_initialized;
}

void C3DEAdManager::RequestRewardedVideoVirtualCurrenciesEarned(const std::string& group, const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeRewardedVideoVirtualCurrenciesCallback>& callback)
{
#ifdef ADS_SPONSOR_PAY
#if defined(PLATFORM_IPHONE)
    [SponsorPaySDK setShowPayoffNotificationOnVirtualCoinsReceived:false];
    C3DESponsorPaySingleton *sharedManager = [C3DESponsorPaySingleton sharedManager];
    [sharedManager requestDeltaOfCoins:callback];
#elif defined(PLATFORM_ANDROID)
    
#endif
#endif
}

void C3DEAdManager::CheckForRewardedVideo(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdAvailabilityCallback>& callback)
{
    if (m_usingFakeAds)
    {
        C3DEThread thread([&, callback]()
        {
            int milliseconds = 5000.0f;
            std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));

            m_fakeVideoOfferRequested = true;

            (*callback)(true, true);
        });
        return;
    }

#if defined(PLATFORM_IPHONE)
#if defined(ADS_SPONSOR_PAY)

    C3DESponsorPaySingleton *sharedManager = [C3DESponsorPaySingleton sharedManager];
    [sharedManager requestVideoOffers:callback];

#endif // if defined(ADS_SPONSOR_PAY)
    
#elif defined(PLATFORM_ANDROID)
#if defined(ADS_APPODEAL)
    C3DESystemManager::GetInstance()->GetAndroidEngine()->CheckForVideoOffers(callback);
#endif
#endif // if defined(PLATFORM_IPHONE)
	
}

bool C3DEAdManager::PlayRewardedVideo(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdVideoFinishedCallback>& callback)
{
    if (m_usingFakeAds)
    {
        m_fakeVideoOfferRequested = false;
        (*callback)(true, true);
        m_showingAd = false;
        return true;
    }

#if defined(PLATFORM_IPHONE)
#if defined(ADS_SPONSOR_PAY)

    UIViewController * viewController = C3DEWrapper::GetInstance()->GetViewController();
    
    C3DESponsorPaySingleton *sharedManager = [C3DESponsorPaySingleton sharedManager];
    [sharedManager playOfferedVideo:viewController callback:callback];
    return true;
#else //if defined(ADS_SPONSOR_PAY)
    return false
#endif
#elif defined(PLATFORM_ANDROID)
#if defined(ADS_APPODEAL)
    return true;
#endif // defined(ADS_APPODEAL)
    return false;
#endif //defined(PLATFORM_IPHONE)
    
    return false;
}

bool C3DEAdManager::IsShowingAd() const
{
    return m_showingAd;
}

// Interstitial
void C3DEAdManager::CheckForInterstitial(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdAvailabilityCallback>& callback)
{
    if (m_usingFakeAds)
    {
        C3DEThread thread([&, callback]()
                          {
                              int milliseconds = 5000.0f;
                              std::this_thread::sleep_for(std::chrono::milliseconds(milliseconds));
                              
                              m_fakeVideoOfferRequested = true;
                              
                              (*callback)(true, true);
                          });
        return;
    }
    
#if defined(PLATFORM_IPHONE)
#if defined(ADS_SPONSOR_PAY)
    
#endif // if defined(ADS_SPONSOR_PAY)
    
#elif defined(PLATFORM_ANDROID)
#if defined(ADS_APPODEAL)
    C3DESystemManager::GetInstance()->GetAndroidEngine()->CheckForInterstitialOffers(callback);
#endif
#endif // if defined(PLATFORM_IPHONE)
    
}

bool C3DEAdManager::ShowInterstitial(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdInterstitialCallback>& callback)
{
    if (m_usingFakeAds)
    {
        m_fakeVideoOfferRequested = false;
        (*callback)(true, true);
        m_showingAd = false;
        return true;
    }
    
#if defined(PLATFORM_IPHONE)

#elif defined(PLATFORM_ANDROID)
#if defined(ADS_APPODEAL)
    C3DESystemManager::GetInstance()->GetAndroidEngine()->ShowInterstitial(callback);
#endif // defined(ADS_APPODEAL)
    return false;
#endif //defined(PLATFORM_IPHONE)
    
    return false;
}

bool C3DEAdManager::HasInterstitial() const
{
    if (m_usingFakeAds)
    {
        return true;
    }
    
#if defined(PLATFORM_IPHONE)
    
#elif defined(PLATFORM_ANDROID)
#if defined(ADS_APPODEAL)
    return C3DESystemManager::GetInstance()->GetAndroidEngine()->HasInterstitial();
#endif // defined(ADS_APPODEAL)
    return false;
#endif //defined(PLATFORM_IPHONE)
    
    return false;
}

