// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module mock::mock_test {
    use sui::coin::{Self, Coin};
    use sui::test_scenario;
    use sui::transfer::{Self};

    use mock::btc::{Self, BTC};
    use mock::eth::{Self, ETH};
    use mock::usdc::{Self, USDC};
    use mock::usdt::{Self, USDT};
    use sui::coin::{TreasuryCap};

    #[test]
    public fun test_mint_burn() {
        let user = @0xA;
        let receipt_a = @0xa0;
        let user_b = @0xB0;

        let scenario_val = test_scenario::begin(user);
        let scenario = &mut scenario_val;
        test_scenario::next_tx(scenario, user);
        let ctx = test_scenario::ctx(scenario);
        btc::init_for_testing(ctx);
        eth::init_for_testing(ctx);
        usdc::init_for_testing(ctx);
        usdt::init_for_testing(ctx);

        test_scenario::next_tx(scenario, user);
        let btc_cap = test_scenario::take_shared<TreasuryCap<BTC>>(scenario);
        coin::mint_and_transfer<BTC>(&mut btc_cap, 100 * 1000_000_000, receipt_a, test_scenario::ctx(scenario));

        let eth_cap = test_scenario::take_shared<TreasuryCap<ETH>>(scenario);
        coin::mint_and_transfer<ETH>(&mut eth_cap, 200 * 1000_000_000, receipt_a, test_scenario::ctx(scenario));

        let usdc_cap = test_scenario::take_shared<TreasuryCap<USDC>>(scenario);
        coin::mint_and_transfer<USDC>(&mut usdc_cap, 300 * 1000_000_000, receipt_a, test_scenario::ctx(scenario));

        let usdt_cap = test_scenario::take_shared<TreasuryCap<USDT>>(scenario);
        coin::mint_and_transfer<USDT>(&mut usdt_cap, 400 * 1000_000_000, receipt_a, test_scenario::ctx(scenario));

        test_scenario::next_tx(scenario, receipt_a);
        let btc_coin = test_scenario::take_from_sender<Coin<BTC>>(scenario);
        let eth_coin = test_scenario::take_from_sender<Coin<ETH>>(scenario);
        let usdc_coin = test_scenario::take_from_sender<Coin<USDC>>(scenario);
        let usdt_coin = test_scenario::take_from_sender<Coin<USDT>>(scenario);
        assert!(coin::value<BTC>(&btc_coin) == 100 * 1000_000_000, 1);
        assert!(coin::value<ETH>(&eth_coin) == 200 * 1000_000_000, 2);
        assert!(coin::value<USDC>(&usdc_coin) == 300 * 1000_000_000, 3);
        assert!(coin::value<USDT>(&usdt_coin) == 400 * 1000_000_000, 4);
        transfer::public_transfer(btc_coin, user_b);

        test_scenario::return_shared(btc_cap);
        test_scenario::return_shared(eth_cap);
        test_scenario::return_shared(usdc_cap);
        test_scenario::return_shared(usdt_cap);
        test_scenario::return_to_sender<Coin<ETH>>(scenario, eth_coin);
        test_scenario::return_to_sender<Coin<USDC>>(scenario, usdc_coin);
        test_scenario::return_to_sender<Coin<USDT>>(scenario, usdt_coin);

        test_scenario::next_tx(scenario, user_b);
        let btc_coin = test_scenario::take_from_sender<Coin<BTC>>(scenario);
        test_scenario::return_to_sender<Coin<BTC>>(scenario, btc_coin);
        
        test_scenario::end(scenario_val);
    }

}
