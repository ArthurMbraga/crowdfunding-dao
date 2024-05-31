/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { ethers } from "ethers";
import {
  DeployContractOptions,
  FactoryOptions,
  HardhatEthersHelpers as HardhatEthersHelpersBase,
} from "@nomicfoundation/hardhat-ethers/types";

import * as Contracts from ".";

declare module "hardhat/types/runtime" {
  interface HardhatEthersHelpers extends HardhatEthersHelpersBase {
    getContractFactory(
      name: "Crowfunding",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Crowfunding__factory>;
    getContractFactory(
      name: "CrowdFunding",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.CrowdFunding__factory>;

    getContractAt(
      name: "Crowfunding",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Crowfunding>;
    getContractAt(
      name: "CrowdFunding",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.CrowdFunding>;

    deployContract(
      name: "Crowfunding",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Crowfunding>;
    deployContract(
      name: "CrowdFunding",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.CrowdFunding>;

    deployContract(
      name: "Crowfunding",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Crowfunding>;
    deployContract(
      name: "CrowdFunding",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.CrowdFunding>;

    // default types
    getContractFactory(
      name: string,
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<ethers.ContractFactory>;
    getContractFactory(
      abi: any[],
      bytecode: ethers.BytesLike,
      signer?: ethers.Signer
    ): Promise<ethers.ContractFactory>;
    getContractAt(
      nameOrAbi: string | any[],
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<ethers.Contract>;
    deployContract(
      name: string,
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<ethers.Contract>;
    deployContract(
      name: string,
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<ethers.Contract>;
  }
}
