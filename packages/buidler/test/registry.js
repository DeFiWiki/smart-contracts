// const deployer = require('../helpers/deployer')(web3, artifacts)
// const { ONE_DAY, bn, bigExp, pct16 } = require('@aragon/contract-helpers-test')
const { assertBn, assertRevert, assertEvent, assertAmountOfEvents } = require('@aragon/contract-helpers-test/src/asserts')




const WikiPagesRegistry = artifacts.require("WikiPagesRegistry");


contract('WikiPagesRegistry', async accounts => {
  const [account1, account2, account3, account4] = accounts;

  const pageName = "wik1";
  const sec1Metadata = [pageName, "abstract", "hash1"];
  const sec2Metadata = [pageName, "tvl", "hash2"];
  const sec3Metadata = [pageName, "marketCap", "hash3"];
  const sec4Metadata = [pageName, "about", "hash4"];
  const sections = [sec1Metadata, sec2Metadata];

  let registryContract;

  describe("My Dapp", function () {

    it("Deploy Registry Contract and add new page", function () {
      it("Should deploy my Registry Contract", async function () {
        registryContract = await WikiPagesRegistry.new();
      });
      context("Add new page", async () => {

      });
      beforeEach("deploy contract + add page", async function () {
        registryContract = await WikiPagesRegistry.new();
        await registryContract.addNewPage(pageName, sections);
      });
      context("Add new Page", async () => {
        it("added new page with two sections", async () => {
          assert(await registryContract.pageExists(pageName) == true);
        });
        it("should fail if page exists", async () => {
          const pageName = "wik1";
          const sec1Metadata = [pageName, "abstract", "hash1"];
          const sec2Metadata = [pageName, "tvl", "hash2"];
          const sections = [sec1Metadata, sec2Metadata];
          await assertRevert(registryContract.addNewPage(pageName, sections), "wiki_page_does_already_exist");
        });
        it("should fail if section exists", async () => {
          const pageName = "wik2";
          const sec1Metadata = [pageName, "abstract", "hash1"];
          const sec2Metadata = [pageName, "tvl", "hash3"];
          const sections = [sec1Metadata, sec2Metadata];
          await assertRevert(registryContract.addNewPage(pageName, sections), "section_hash_already_exists");
        });
        it("should fail if maintainer of newly created section is a zero address", async () => {
          const newSectionMaintainer = await registryContract.pageSectionMaintainer(sections[0][2]);
          await assert(newSectionMaintainer != 0x0000000000000000000000000000000000000000 && newSectionMaintainer == 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
        });
        it("check if position of wik2 page and its last section updates", async () => {
          const pagePos = await registryContract.pagePositionInArray("wik1");
          const lastSec = await registryContract.lastSectionInArray("wik1");
          assert(pagePos == "1");
          assert(lastSec == "1");
        });
      });
      context("Add new section", async () => {
        it("should create two new sections and update last section mapping", async () => {
          const pageName = "wik1";
          const sections = [sec3Metadata, sec4Metadata];
          await registryContract.addNewSections(pageName, sections);
          const lastSec = await registryContract.lastSectionInArray("wik1");
          assert(lastSec == "3");
        });
        it("should fail if page does not exist", async () => {
          const pageName = "wik2";
          const sections = [sec3Metadata, sec4Metadata];
          await assertRevert(registryContract.addNewSections(pageName, sections), "wiki page does not exist");
        });
        it("should fail if section with same hash exists", async () => {
          const pageName = "wik1";
          const sections = [sec1Metadata, sec4Metadata];
          await assertRevert(registryContract.addNewSections(pageName, sections), "section_hash_already_exists");
        });
        it("should fail if maintainer of a new section is a zero address", async () => {
          const pageName = "wik1";
          const sections = [sec3Metadata, sec4Metadata];
          await registryContract.addNewSections(pageName, sections);
          const newSectionMaintainer = await registryContract.pageSectionMaintainer(sections[1][2]);
          await assert(newSectionMaintainer != 0x0000000000000000000000000000000000000000 && newSectionMaintainer == 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF)
        });
      })
      context("Update section", async () => {
        beforeEach("deploy contract + add page + set account1 maintainer ", async function () {
          await registryContract.changeMaintainer(1, 0, account1);
          const pageName2 = "wik2";
          const sections2 = [sec3Metadata, sec4Metadata];
          await registryContract.addNewPage(pageName2, sections2);
        })
        it("should update section and check maintainer and check previous hash", async () => {
          const pageName = "wik1";
          const sectionHash = "hash34";
          await registryContract.updateSection(1, 0, sectionHash, { from: account1 });

          const newSection = await registryContract.wikiPages(1, 0);
          assert(newSection == sectionHash);
          const secMaintainer = await registryContract.pageSectionMaintainer(sectionHash);
          assert(secMaintainer == account1);
          const previousHash = await registryContract.getPreviousHash(sectionHash);
          assert(previousHash == "hash1");
        })
        it("should fail if msg sender not maintainer", async () => {
          const pageName = "wik1";
          const sectionHash = "hash3";
          await assertRevert(registryContract.updateSection(1, 0, sectionHash, { from: account2 }), "you are not maintainer for this section");
        })
        it("should fail if section hash already exists", async () => {
          const pageName = "wik1";
          const sectionHash = sec4Metadata[2];
          await assertRevert(registryContract.updateSection(1, 0, sectionHash, { from: account1 }), "section already exists, please include metadata");
        })
      });
    });
  });
});
