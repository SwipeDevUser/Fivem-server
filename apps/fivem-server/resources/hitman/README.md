# Hitman Contract System

Discrete. Professional. Deadly.

## Overview

This resource implements a realistic hitman contract system with the following features:

- **Kill Tracking**: Automatically tracks player kills
- **Job Unlock**: Requires **10+ kills** to unlock the hitman job
- **iPhone App**: Access contracts via the Hitman app on your iPhone
- **Contract System**: Receive discrete contracts with target locations and payment
- **Social Media Integration**: Can post about hitman services online

## Gameplay

### Unlocking Hitman

1. Eliminate 10+ targets around the city
2. System automatically unlocks hitman job
3. Chat notification confirms unlock
4. Hitman app appears on iPhone

### Working as Hitman

1. Download **Hitman** app on iPhone
2. `/startmission` - Start hitman mode
3. View available contracts via iPhone app
4. Complete contract - Go to target location
5. `/completehit` - Confirm contract completion and collect payment

### Commands

- `/killcount` - Check kill count and hitman status
- `/hitmancheckstatus` - See how many kills needed for unlock
- `/startmission` - Clock in as hitman (requires 10+ kills)
- `/completehit` - Complete active contract

## Features

- **Realistic Progression**: Must prove yourself before becoming hitman
- **Discord-like Contracts**: Receive contracts via iPhone messaging
- **Variable Pay**: Contracts pay based on target distance/difficulty
- **Stealth Gameplay**: Complete contracts discretely
- **Social Media**: Advertise services to attract clients

## Integration

The hitman system integrates with:
- **Jobs System**: Dedicated hitman job when unlocked
- **iPhone System**: Hitman app for contract access
- **Kill Tracking**: Automatic detection of player eliminations
- **Inventory System**: Payment delivered to cash inventory

## Notes

- Hitman kills don't count against your kill signature
- Contracts are posted anonymously on social media
- Law enforcement can investigate hitman activity
- Multiple contracts available simultaneously
