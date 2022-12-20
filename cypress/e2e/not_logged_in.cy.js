describe('Not logged in', function () {


  it('Visits the main page', function () {
    cy.visit('http://localhost:4000')
    cy.contains('My name is Alan Vardy, I am a Senior Developer')
    
  })
  
  it('Visits the blog page', function () {
    cy.visit('http://localhost:4000')
    cy.get('[href="/blog"]').first().click();
    cy.contains('Previous')
    cy.contains('Next')
    
  })
  
  it('Clicks on an elixir tag', function () {
    cy.visit('http://localhost:4000')
    cy.get('[href="/blog"]').first().click();
    
    cy.contains('elixir').click();
    cy.contains('#elixir')
  })
  
  it('Visits the about me page', function () {
    cy.visit('http://localhost:4000')
    
    cy.get('[href="/aboutme"]').first().click();
    cy.contains('This is the part where I get to talk about myself!')
  })
  
  it('Visits the contact page', function () {
    cy.visit('http://localhost:4000')
    cy.get('[href="/contact"]').first().click();
    cy.contains('Guilherme Stecanella')

  })
})
