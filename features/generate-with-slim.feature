Feature: Generate slides

  In order to easily generate reveal.js presentations
  As a user of reveal-ck
  I want to use the "reveal-ck generate" command

  Scenario: Generating basic slides with slides.slim
    Given a file named "slides.slim" with:
    """
    section
      p Slides with Slim
    """
    When I run `reveal-ck generate`
    Then the exit status should be 0
    And the output should contain exactly "Generating slides for 'slides.slim'..\n"
    And the following files should exist:
    | slides/slides.html |
    | slides/index.html  |
    And the file "slides/slides.html" should contain:
    """
    <section>
      <p>
        Slides with Slim
      </p>
    </section>
    """
    And the file "slides/index.html" should contain:
    """
    <section>
      <p>
        Slides with Slim
      </p>
    </section>
    """
    And the file "slides/index.html" should contain:
    """
    <title>Slides</title>
    """
    And the file "slides/index.html" should contain:
    """
    <meta name="author" content="">
    """
    And the file "slides/index.html" should contain:
    """
    <link rel="stylesheet" href="css/theme/default.css" id="theme">
    """
    And the file "slides/index.html" should contain:
    """
    transition: Reveal.getQueryHash().transition || 'default'
    """
