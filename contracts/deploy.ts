import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  const Timelock = await ethers.getContractFactory("Sky4Timelock");
  const timelock = await Timelock.deploy(2 * 24 * 60 * 60, [], []);

  const Token = await ethers.getContractFactory("Sky4Token");
  const token = await Token.deploy(await timelock.getAddress());

  const Treasury = await ethers.getContractFactory("Sky4Treasury");
  const treasury = await Treasury.deploy(await token.getAddress());

  const Staking = await ethers.getContractFactory("Sky4Staking");
  const staking = await Staking.deploy(await token.getAddress(), ethers.parseEther("0.01"));

  console.log({
    timelock: await timelock.getAddress(),
    token: await token.getAddress(),
    treasury: await treasury.getAddress(),
    staking: await staking.getAddress()
  });
}

main();