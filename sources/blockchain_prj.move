module MyModule::BadgeSystem {
    use aptos_framework::signer;
    use std::string::{Self, String};
    use std::vector;

    /// Struct representing an academic badge/NFT
    struct Badge has store, key, copy, drop {
        badge_id: u64,           // Unique identifier for the badge
        title: String,           // Badge title (e.g., "Mathematics Excellence")
        recipient: address,      // Address of the badge recipient
        issuer: address,         // Address of the institution/issuer
        timestamp: u64,          // When the badge was issued
    }

    /// Struct to store all badges for an account
    struct BadgeCollection has store, key {
        badges: vector<Badge>,   // Vector of all badges owned
        next_badge_id: u64,      // Counter for generating unique badge IDs
    }

    /// Function to initialize badge collection for a new user
    public fun initialize_collection(account: &signer) {
        let collection = BadgeCollection {
            badges: vector::empty<Badge>(),
            next_badge_id: 1,
        };
        move_to(account, collection);
    }

    /// Function to mint/issue a new academic badge to a recipient
    public fun mint_badge(
        issuer: &signer,
        recipient_address: address,
        title: String
    ) acquires BadgeCollection {
        let issuer_address = signer::address_of(issuer);
        
        // Check if recipient has a collection, if not create one
        if (!exists<BadgeCollection>(recipient_address)) {
            // For simplicity, we'll assume collection exists or handle elsewhere
            abort 1 // Collection must exist
        };

        let collection = borrow_global_mut<BadgeCollection>(recipient_address);
        
        let new_badge = Badge {
            badge_id: collection.next_badge_id,
            title,
            recipient: recipient_address,
            issuer: issuer_address,
            timestamp: 0, // In real implementation, use timestamp::now_seconds()
        };

        vector::push_back(&mut collection.badges, new_badge);
        collection.next_badge_id = collection.next_badge_id + 1;
    }
}