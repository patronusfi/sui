module mock::btc {
    use sui::tx_context::{TxContext};
    use sui::coin::{Self};
    use std::option;
    use sui::transfer;

    struct BTC has drop {}

    fun init(witness: BTC, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<BTC>(witness, 9, b"BTC", b"BTC", b"BTC testnet", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }
    #[test_only] public fun init_for_testing(ctx: &mut TxContext) { init(BTC {}, ctx) }
}
