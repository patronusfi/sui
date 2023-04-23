module mock::eth {
    use sui::tx_context::{TxContext};
    use sui::coin::{Self};
    use std::option;
    use sui::transfer;

    struct ETH has drop {}

    fun init(witness: ETH, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<ETH>(witness, 9, b"ETH", b"ETH", b"ETH testnet", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury_cap);
    }
    #[test_only] public fun init_for_testing(ctx: &mut TxContext) { init(ETH {}, ctx) }
}
