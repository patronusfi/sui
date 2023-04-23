module mock::usdc {
    use sui::tx_context::{TxContext};
    use sui::coin::{Self};
    use std::option;
    use sui::transfer;

    struct USDC has drop {}

    fun init(witness: USDC, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<USDC>(witness, 9, b"USDC", b"USDC", b"USDC testnet", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }

    #[test_only] public fun init_for_testing(ctx: &mut TxContext) { init(USDC {}, ctx) }
}
