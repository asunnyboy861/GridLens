# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: GridLens Premium
- **Group ID**: GridLens_Premium

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Premium
- **Product ID**: `com.zzoutuo.GridLens.monthly`
- **Price**: $4.99 per month
- **Display Name**: GridLens Monthly
- **Description**: Full AR grid overlay features
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Premium
- **Product ID**: `com.zzoutuo.GridLens.yearly`
- **Price**: $29.99 per year (50% savings vs monthly)
- **Display Name**: GridLens Yearly
- **Description**: Best value for professionals
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.GridLens.lifetime`
- **Price**: $59.99 one-time
- **Display Name**: GridLens Lifetime
- **Description**: One-time purchase, forever access
- **Localization**: English (US)

## Free Trial
- **Duration**: 3 days
- **Type**: Free trial (auto-converts to paid)

## Policy Pages Required
- Support Page: Yes (Must include subscription management info)
- Privacy Policy: Yes
- Terms of Use: Yes (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented
