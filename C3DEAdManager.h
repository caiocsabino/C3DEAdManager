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
    typedef C3DEDelegate<void, bool, double, const std::string&, const std::string&> TypeVirtualCurrenciesCallback;
    
    typedef C3DEDelegate<void, bool, bool> TypeVideoOfferCallback;
    
    typedef C3DEDelegate<void, bool, bool> TypeVideoFinishedCallback;
};

class C3DEAdManager : public Singleton<C3DEAdManager>
{
public:
    C3DEAdManager();
    ~C3DEAdManager();

    void SetUsingFakeAds(bool useFakeAds);

    inline bool GetUsingFakeAds() const { return m_usingFakeAds; }
    
    bool InitializeAdOfferings(const std::string& appID, const std::string& appSecret, const std::string& userID = "");
    
    bool HasVideoOffer() const;
    
    bool GetIsAdOfferInitialized() const;
    
    void RequestVirtualCurrenciesEarned(const std::string& name, const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeVirtualCurrenciesCallback>& callback);
    
    void CheckForVideoOffers(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeVideoOfferCallback>& callback);
    
    bool PlayOfferedVideo(const std::shared_ptr<C3DEServiceAdsManagerCallback::TypeVideoFinishedCallback>& callback);
    
    bool IsShowingAd() const;
    
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
