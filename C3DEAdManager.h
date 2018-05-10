#ifndef C3DE_AD_MANAGER_H
#define C3DE_AD_MANAGER_H

#include "Singleton.h"
#include "C3DEDelegate.h"
#include <memory>
#include <string>
#include <map>

class C3DEServiceAdsManagerCallback
{
public:
    // rewarded video
    typedef C3DEDelegate<void, bool, double, const std::string&, const std::string&> TypeRewardedVideoVirtualCurrenciesCallback;
    
    // success, offers available
    typedef C3DEDelegate<void, bool, bool> TypeAdAvailabilityCallback;
    
    // success, played until the end, currency amount, currency name
    typedef C3DEDelegate<void, bool, bool, double, const std::string&> TypeAdVideoFinishedCallback;
    
    // success, clicked = true, closed = false
    typedef C3DEDelegate<void, bool, bool> TypeAdInterstitialCallback;

};

class C3DEAdManager : public Singleton<C3DEAdManager>
{
public:
    C3DEAdManager();
    ~C3DEAdManager();

    void SetUsingFakeAds(bool useFakeAds);

    inline bool GetUsingFakeAds() const { return m_usingFakeAds; }
    
    bool InitializeAdOfferings(const std::string& appID, const std::string& appSecret, const std::string& userID = "", int arguments = 0);
    
    bool GetIsAdOfferInitialized() const;
    
    // Rewarded videos
    bool HasRewardedVideo() const;
    
    void RequestRewardedVideoVirtualCurrenciesEarned(const std::string& name, const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeRewardedVideoVirtualCurrenciesCallback>& callback);
    
    void CheckForRewardedVideo(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdAvailabilityCallback>& callback);
    
    bool PlayRewardedVideo(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdVideoFinishedCallback>& callback);
    
    bool IsShowingAd() const;
    
    // Interstitial
    void CheckForInterstitial(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdAvailabilityCallback>& callback);
    
    bool ShowInterstitial(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeAdInterstitialCallback>& callback);
    
    bool HasInterstitial() const;
    
    // Banners
    
private:
    
	bool m_offersInitializationRequested;

	bool m_fakeVideoOfferRequested;

    bool m_usingFakeAds;

    bool m_initialized;

    bool m_showingAd;
    std::string m_applicationID;
    std::string m_userID;
    std::string m_securityToken;
    
};

#endif
