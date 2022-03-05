describe('Not logged in', function () {
  beforeEach(function () {
    // before each test, we can automatically preserve the
    // 'session_id' and 'remember_token' cookies. this means they
    // will not be cleared before the NEXT test starts.
    //
    // the name of your cookies will likely be different
    // this is just a simple example
    Cypress.Cookies.debug(true)
    Cypress.Cookies.preserveOnce('_alanvardy_key')
  })

  it('Visits the main page', function () {
    cy.visit('http://localhost:4000')
    cy.contains('My name is Alan Vardy, I am a Senior Developer')
  })

  it('Visits the blog page', function () {
    cy.get('[href="/blog"]').first().click();
    cy.contains('Previous')
    cy.contains('Next')
  })

  it('Visits the about me page', function () {
    cy.get('[href="/aboutme"]').first().click();
    cy.contains('This is the part where I get to talk about myself!')
  })
})
