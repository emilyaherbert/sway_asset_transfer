use fuels::prelude::*;
use fuels::tx::{AssetId, ContractId};

abigen!(Banking, "out/debug/banking-abi.json");

const ASSET_ID: [u8; 32] = [
    7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
];

#[tokio::test]
async fn can_deposit() {
    let (_, [deployer, _]) = setup_tests().await;

    deposit_helper(&deployer, 1_000).await;
    assert_eq!(get_balance(&deployer).await, 999_000);
}

struct User {
    banking_handle: Banking,
    wallet: WalletUnlocked,
}

async fn setup_tests() -> (ContractId, [User; 2]) {
    let asset_ids = [AssetId::default(), AssetId::from(ASSET_ID)];
    let asset_configs = asset_ids
        .map(|id| AssetConfig {
            id,
            num_coins: 1,
            coin_amount: 1_000_000,
        })
        .into();
    let wallet_config = WalletsConfig::new_multiple_assets(2, asset_configs);
    let mut wallets = launch_custom_provider_and_get_wallets(wallet_config, None).await;
    let deployer_wallet = wallets.pop().unwrap();
    let receiver_wallet = wallets.pop().unwrap();

    let banking_id = Contract::deploy(
        "out/debug/banking.bin",
        &deployer_wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "out/debug/banking-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let deployer = User {
        banking_handle: Banking::new(banking_id.to_string(), deployer_wallet.clone()),
        wallet: deployer_wallet,
    };
    let receiver = User {
        banking_handle: Banking::new(banking_id.to_string(), receiver_wallet.clone()),
        wallet: receiver_wallet,
    };

    (banking_id.into(), [deployer, receiver])
}

async fn deposit_helper(user: &User, amount: u64) {
    let call_params = CallParameters::new(
        Some(amount),                  // amount
        Some(AssetId::from(ASSET_ID)), // asset ID
        Some(5_000),                   // gas forwarded
    );

    user.banking_handle
        .methods()
        .deposit()
        .call_params(call_params)
        .call()
        .await
        .unwrap();
}

async fn get_balance(user: &User) -> u64 {
    user.wallet
        .get_asset_balance(&AssetId::from(ASSET_ID))
        .await
        .unwrap()
}
