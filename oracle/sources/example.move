module oracle::example {
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::vec_map::{Self, VecMap};
    use std::vector::{Self};

    use SupraOracle::SupraSValueFeed::{get_price, get_prices, extract_price, OracleHolder};

    struct ExampleHolder has key, store {
        id: UID,
        feeds: VecMap<u32, ExampleEntry>,
    }

    struct ExampleEntry has store, copy, drop {
        value: u128,
        decimal: u16,
        timestamp: u128,
        round: u64
    }

    fun init(ctx: &mut TxContext) {
        let resource = ExampleHolder {
            id: object::new(ctx),
            feeds: vec_map::empty<u32, ExampleEntry>(),
        };
        transfer::share_object(resource);
    }

    fun update_price(resource: &mut ExampleHolder, pair: u32, value: u128, decimal: u16, timestamp: u128, round: u64) {
        let feeds = resource.feeds;
        if (vec_map::contains(&feeds, &pair)) {
            let feed = vec_map::get_mut(&mut resource.feeds, &pair);
            feed.value = value;
            feed.decimal = decimal;
            feed.timestamp = timestamp;
            feed.round = round;
        } else {
            let entry = ExampleEntry { value, decimal, timestamp, round };
            vec_map::insert(&mut resource.feeds, pair, entry);
        };
    }

    public entry fun get_update_price(
        oracle_holder: &OracleHolder,
        resource: &mut ExampleHolder,
        pair: u32,
        _ctx: &mut TxContext
    ) {
        let (value, decimal, timestamp, round) = get_price(oracle_holder, pair);
        update_price(resource, pair, value, decimal, timestamp, round);
    }

    public entry fun get_update_prices(
        oracle_holder: &OracleHolder,
        resource: &mut ExampleHolder,
        pairs: vector<u32>,
        _ctx: &mut TxContext
    ) {
        let prices = get_prices(oracle_holder, pairs);
        let n = vector::length(&prices);
        let i = 0;


        while (i < n) {
            let price = vector::borrow(&prices, i);
            let (pair, value, decimal, timestamp, round) = extract_price(price);
            update_price(resource, pair, value, decimal, timestamp, round);
            i = i + 1;
        }
    }
}
