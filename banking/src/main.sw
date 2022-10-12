contract;

use banking_abi::Banking;

use std::{
    context::{
        msg_amount,
        this_balance,
    },
    token::{
        transfer,
        transfer_to_address,
    },
    chain::auth::msg_sender,
    logging::log,
};

impl Banking for Contract {
    /// Deposit assets into the contract.
    fn deposit() {
        assert(msg_amount() > 0);
    }

    /// Withdraw assets from the contract.
    fn withdraw(amount: u64, asset_id: ContractId) {
        let sender = msg_sender().unwrap();
        assert(this_balance(asset_id) >= amount);
        transfer(amount, asset_id, sender);
    }

    /// Transfer assets directly to a recipient.
    fn transfer_assets_to_recipient(amount: u64, asset_id: ContractId, recipient: Address) {
        assert(this_balance(asset_id) >= amount);
        transfer_to_address(amount, asset_id, recipient);
    }
}
