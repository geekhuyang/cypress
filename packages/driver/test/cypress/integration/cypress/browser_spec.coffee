_ = Cypress._

browserProps = require("../../../../src/cypress/browser")

describe "src/cypress/browser", ->
  beforeEach ->
    @commands = (browser = { name: "chrome", family: "chromium" }) ->
      browserProps({ browser })

  context ".browser", ->
    it "returns the current browser", ->
      expect(@commands().browser).to.eql({ name: "chrome", family: "chromium" })

  context ".isBrowser", ->
    it "returns true if it's a match", ->
      expect(@commands().isBrowser("chrome")).to.be.true
      expect(@commands().isBrowser({ family: 'chromium' })).to.be.true

    it "returns false if it's not a match", ->
      expect(@commands().isBrowser("firefox")).to.be.false

    it "is case-insensitive", ->
      expect(@commands().isBrowser("Chrome")).to.be.true


    it 'can match with exclusives', ->
      expect(@commands().isBrowser(['!firefox'])).to.be.true
      expect(@commands().isBrowser({ family: 'chromium', name: '!firefox' })).to.be.true

      expect(@commands().isBrowser({ family: '!chromium' })).to.be.false
      expect(@commands().isBrowser({ family: 'chromium', name: '!chrome' })).to.be.false

    it "can accept an array of matchers", ->
      expect(@commands().isBrowser(['firefox', 'chrome'])).to.be.true
      expect(@commands().isBrowser(['chrome', '!firefox'])).to.be.true
      expect(@commands().isBrowser([{ family: '!chromium' }, '!firefox', 'chrome'])).to.be.true

      expect(@commands().isBrowser([{ family: '!chromium' }, '!firefox'])).to.be.false
      expect(@commands().isBrowser(['!chrome', '!firefox'])).to.be.false
      expect(@commands().isBrowser(['!chrome', '!firefox'])).to.be.false
      expect(@commands().isBrowser(['!firefox', '!chrome'])).to.be.false
      expect(@commands().isBrowser([])).to.be.false

    it "throws if arg is not a string, object, or non-empty array", ->
      expect =>
        @commands().isBrowser(true)
      .to.throw("`Cypress.isBrowser()` must be passed the name of a browser, an object to filter with, or an array of either. You passed: `true`")

    it "returns true if it's a match or a 'parent' browser", ->
      expect(@commands().isBrowser("chrome")).to.be.true
      expect(@commands({ name: "electron" }).isBrowser("chrome")).to.be.false
      expect(@commands({ name: "chromium" }).isBrowser("chrome")).to.be.false
      expect(@commands({ name: "canary" }).isBrowser("chrome")).to.be.false
      expect(@commands({ name: "firefox" }).isBrowser("firefox")).to.be.true
      expect(@commands({ name: "ie" }).isBrowser("ie")).to.be.true

    it "matches on name if has unknown family", ->
      expect(@commands({ name: 'customFoo'}).isBrowser("customfoo")).to.be.true
