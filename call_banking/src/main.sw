script;

use banking_abi::Banking;

const BANKING_ID = 0x9ae5b658754e096e4d681c548daf46354495a437cc61492599e33fc64dcdc30c;
const ASSET_ID = 0x7777_7777_7777_7777_7777_7777_7777_7777_7777_7777_7777_7777_7777_7777_7777_7777;
const RECIPIENT = ~Address::from(0x9299da6c73e6dc03eeabcce242bb347de3f5f56cd1c70926d76526d7ed199b8b);

fn main() {
    let banking = abi(Banking, BANKING_ID);
    banking.deposit {
        gas: 5000,
        coins: 1000,
        asset_id: ASSET_ID
    }();
    let asset_id = ~ContractId::from(ASSET_ID);
    banking.transfer_assets_to_recipient(500, asset_id, RECIPIENT);
    banking.withdraw(500, asset_id);
}
