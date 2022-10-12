library banking_abi;

abi Banking {
    fn deposit();
    fn withdraw(amount: u64, asset_id: ContractId);
    fn transfer_assets_to_recipient(amount: u64, asset_id: ContractId, recipient: Address);
}
