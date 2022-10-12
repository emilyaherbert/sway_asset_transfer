contract;

use std::{
    context::call_frames::{
        contract_id,
        msg_asset_id,
    },
    context::{
        msg_amount,
        this_balance,
    },
    token::{
        mint_to_address,
        transfer_to_address,
        burn,
    },
};

const ACCEPTED_TOKEN = ~ContractId::from(0x9ae5b658754e096e4d681c548daf46354495a437cc61492599e33fc64dcdc30c);

abi TokenPool {
    fn deposit(recipient: Address);
    fn withdraw(recipient: Address);
}

impl TokenPool for Contract {
    fn deposit(recipient: Address) {
        let asset_id = msg_asset_id();
        let amount = msg_amount();

        assert(asset_id == ACCEPTED_TOKEN);
        assert(amount > 0);

        // Mint the contract token and send it to the recipient.
        // We can find the contract token asset id by using the standard library function "contract_id()".
        mint_to_address(amount, recipient);
    }

    fn withdraw(recipient: Address) {
        let asset_id = msg_asset_id();
        let amount = msg_amount();
        let contract_asset_id = contract_id();

        assert(asset_id == contract_asset_id);
        assert(amount > 0);
        assert(this_balance(contract_asset_id) >= amount);

        // Transfer the original token back to the recipient.
        transfer_to_address(amount, ACCEPTED_TOKEN, recipient);
        // Burn the contract tokens that were sent back.
        burn(amount);
    }
}
