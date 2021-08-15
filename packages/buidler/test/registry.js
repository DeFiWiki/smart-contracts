const { assertBn, assertRevert, assertEvent, assertAmountOfEvents } = require('@aragon/contract-helpers-test/src/asserts')

const WikiPagesRegistry = artifacts.require("WikiPagesRegistry");


describe("My Dapp", function () {
  let accounts;
  let myContract;
  before(async function () {
    accounts = await web3.eth.getAccounts();
    [account1, account2, account3, account4] = accounts;
  });
  describe("Deploy Registry Contract and add new page", function () {
    it("Should deploy my Registry Contract", async function () {
      const registryContract = await WikiPagesRegistry.new();
    });
    context("Add new page", async () => {
      it("adding new page with two sections", async () => {
        const registryContract = await WikiPagesRegistry.new();
        const pageName = "wik1";
        const sec1Metadata = [pageName, "abstract", "hash1"];
        const sec2Metadata = [pageName, "tvl", "hash2"];
        const sections = [sec1Metadata, sec2Metadata];
        await registryContract.addNewPage(pageName, sections);
        console.log(await registryContract.getSectionMetadata("hash2"));
        console.log(await registryContract.pageSectionMaintainer("hash2"));
      });
    });
    context("Add new Page", async () => {
      beforeEach("deploy contract + add page", async function () {
        const registryContract = await WikiPagesRegistry.new();
        const pageName = "wik1";
        const sec1Metadata = [pageName, "abstract", "hash1"];
        const sec2Metadata = [pageName, "tvl", "hash2"];
        const sections = [sec1Metadata, sec2Metadata];
        await registryContract.addNewPage(pageName, sections);
      })

      it("should fail if page exists", async () => {
        const newpageName = "wik1";
        const newsections = ["hash3", "hash4"];
        await assertRevert(registryContract.addNewPage(newpageName, newsections));
      });
      it("should fail if section exists", async () => {
        const pageName = "wik2";
        const sections = ["hash1", "hash4"];
        await assertRevert(registryContract.addNewPage(pageName, sections));
      });
      it("should fail if maintainer of newly created section is a zero address", async () => {
        const pageName = "wik2";
        const sections = ["hash3", "hash4"];
        await registryContract.addNewPage(pageName, sections);
        const newSectionMaintainer = await registryContract.pageSectionMaintainer(sections[0]);
        await assert(newSectionMaintainer != 0x0000000000000000000000000000000000000000 && newSectionMaintainer == 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
      });
      it("check if position of wik2 page and its last section updates", async () => {
        const pageName = "wik2";
        const sections = ["hash3", "hash4"];
        await registryContract.addNewPage(pageName, sections);
        const pagePos = await registryContract.pagePositionInArray("wik2");
        const lastSec = await registryContract.lastSectionInArray("wik2");
        assert(pagePos == "2");
        assert(lastSec == "1");
      });
    });
    context("Add new section", async () => {
      beforeEach("deploy contract + add page", async function () {
        registryContract = await WikiPagesRegistry.new();
        const pageName = "wik1";
        const sections = ["hash1", "hash2"];
        await registryContract.addNewPage(pageName, sections);
      })
      it("should create two new sections and update last section mapping", async () => {
        const pageName = "wik1";
        const sections = ["hash3", "hash4"];
        await registryContract.addNewSections(pageName, sections);
        const lastSec = await registryContract.lastSectionInArray("wik1");
        assert(lastSec == "3");
      });
      it("should fail if page does not exist", async () => {
        const pageName = "wik2";
        const sections = ["hash3", "hash4"];
        await assertRevert(registryContract.addNewSections(pageName, sections));
      });
      it("should fail if section with same hash exists", async () => {
        const pageName = "wik1";
        const sections = ["hash1", "hash4"];
        await assertRevert(registryContract.addNewSections(pageName, sections));
      });
      it("should fail if maintainer of a new section is a zero address", async () => {
        const pageName = "wik1";
        const sections = ["hash3", "hash4"];
        await registryContract.addNewSections(pageName, sections);
        const newSectionMaintainer = await registryContract.pageSectionMaintainer(sections[1]);
        await assert(newSectionMaintainer != 0x0000000000000000000000000000000000000000 && newSectionMaintainer == 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
      });
    })
    context("Update section", async () => {
      beforeEach("deploy contract + add page + set account1 maintainer", async function () {
        registryContract = await WikiPagesRegistry.new();
        const pageName = "wik1";
        const sections = ["hash1", "hash2"];
        await registryContract.addNewPage(pageName, sections);
        await registryContract.changeMaintainer(1, 0, account1);
        const pageName2 = "wik2";
        const sections2 = ["hash21", "hash22"];
        await registryContract.addNewPage(pageName2, sections2);
      })
      it("should update section + check maintainer + check previous hash + update section metadata ", async () => {
        const pageName = "wik1";
        const section = "hash3";
        await registryContract.updateSection(1, 0, section, { from: account1 });

        const newSection = await registryContract.wikiPages(1, 0);
        assert(newSection == "hash3");
        const secMaintainer = await registryContract.pageSectionMaintainer(section);
        assert(secMaintainer == account1);
        const previousHash = await registryContract.getPreviousHash(section);
        assert(previousHash == "hash1");
        const sectionMetadata = await registryContract.getSectionMetadata(newSection);
        console.log(sectionMetadata);
        assert(await sectionMetadata.currentHash == newSection);
      })
      it("should fail if msg sender not maintainer", async () => {
        const pageName = "wik1";
        const section = "hash3";
        await assertRevert(registryContract.updateSection(1, 0, section, { from: account2 }));
      })
      it("should fail if section hash already exists", async () => {
        const pageName = "wik1";
        const section = "hash22";
        await assertRevert(registryContract.updateSection(1, 0, section, { from: account1 }));
      })
    });
  });
});
