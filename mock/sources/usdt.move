module mock::usdt {
    use sui::tx_context::{TxContext};
    use sui::coin::{Self};
    use std::option;
    use sui::transfer;

    struct USDT has drop {}
    
    fun init(witness: USDT, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<USDT>(witness, 9, b"USDT", b"USDT", b"USDT testnet", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }

    #[test_only] public fun init_for_testing(ctx: &mut TxContext) { init(USDT {}, ctx) }
}
