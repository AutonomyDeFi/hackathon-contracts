import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract, ContractFactory } from "ethers";
import { ethers } from "hardhat";

async function main() {
  // // // // // // // // // // // // // // // // // // // //
  // ADDRESS SIGNERS
  // // // // // // // // // // // // // // // // // // // //

  // Addresses
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];
  [deployer, addr1, addr2, ...addrs] = await ethers.getSigners();

  // // // // // // // // // // // // // // // // // // // //
  // PLAYGROUND
  // // // // // // // // // // // // // // // // // // // //
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
