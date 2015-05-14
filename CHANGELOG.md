# Change Log

## [Unreleased](https://github.com/thoughtbot/factory_girl/tree/HEAD)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v4.5.0...HEAD)

**Closed issues:**

- Self-referential association inside trait doesn't work [\#765](https://github.com/thoughtbot/factory_girl/issues/765)

- Getting Started Guide Garbled [\#764](https://github.com/thoughtbot/factory_girl/issues/764)

- Sequence starting at no. 2 [\#763](https://github.com/thoughtbot/factory_girl/issues/763)

- Multiple associations in factories [\#758](https://github.com/thoughtbot/factory_girl/issues/758)

- Factory with invalid built association gets created nonetheless  [\#755](https://github.com/thoughtbot/factory_girl/issues/755)

- Extending existing factory class by adding more traits. [\#752](https://github.com/thoughtbot/factory_girl/issues/752)

- Use of FG lint and sequence numbers breaks the generated sequence in tests [\#750](https://github.com/thoughtbot/factory_girl/issues/750)

- How do I know if my model is being build, created or stubbed? [\#745](https://github.com/thoughtbot/factory_girl/issues/745)

- What if my model has an attribute named sequence? [\#744](https://github.com/thoughtbot/factory_girl/issues/744)

- Image file attribute is missing randomly [\#739](https://github.com/thoughtbot/factory_girl/issues/739)

- Skip AR callbacks [\#736](https://github.com/thoughtbot/factory_girl/issues/736)

- belongs\_to and validates :presence validations failing [\#735](https://github.com/thoughtbot/factory_girl/issues/735)

- Callbacks not firing? [\#733](https://github.com/thoughtbot/factory_girl/issues/733)

- Pass Hash with attributes [\#731](https://github.com/thoughtbot/factory_girl/issues/731)

- Specifying associations to inherited factory with FactoryGirl [\#730](https://github.com/thoughtbot/factory_girl/issues/730)

- \[QUESTION\] Populating huge data presets [\#729](https://github.com/thoughtbot/factory_girl/issues/729)

- FactoryGirl association not allowing multiple traits input [\#728](https://github.com/thoughtbot/factory_girl/issues/728)

- README.md is unreadable when access from "GETTING STARTED" [\#727](https://github.com/thoughtbot/factory_girl/issues/727)

- `FactoryGirl.lint` behavior differs from documentation [\#726](https://github.com/thoughtbot/factory_girl/issues/726)

- FactoryGirl\#create slowdown in Rails 4.2beta4 [\#725](https://github.com/thoughtbot/factory_girl/issues/725)

- stubbed models which access the db inside a lock statement generate wrong error [\#719](https://github.com/thoughtbot/factory_girl/issues/719)

- Rspec not cleaning factories after upgrade. [\#716](https://github.com/thoughtbot/factory_girl/issues/716)

- Linting factories for objects without `save!` method [\#712](https://github.com/thoughtbot/factory_girl/issues/712)

- Save instances with random ids? [\#711](https://github.com/thoughtbot/factory_girl/issues/711)

- Are sequences threadsafe? [\#705](https://github.com/thoughtbot/factory_girl/issues/705)

- undefined method `allow' for \#<FactoryGirl::SyntaxRunner:0x007fd2c9978b20\> [\#703](https://github.com/thoughtbot/factory_girl/issues/703)

- Where do you place modified factories? [\#701](https://github.com/thoughtbot/factory_girl/issues/701)

- "no receiver given" when trying to use short form for dynamic attributes [\#698](https://github.com/thoughtbot/factory_girl/issues/698)

- Linting with Dependent Association [\#696](https://github.com/thoughtbot/factory_girl/issues/696)

- Suggestion:  Add error messages to FactoryGirl.lint output [\#691](https://github.com/thoughtbot/factory_girl/issues/691)

- How best to use with rspec controller tests [\#676](https://github.com/thoughtbot/factory_girl/issues/676)

- multiple factory directories [\#673](https://github.com/thoughtbot/factory_girl/issues/673)

- Segmentation fault on recursive association reference [\#628](https://github.com/thoughtbot/factory_girl/issues/628)

- Generated factories in Rails Engine incorrectly namespaced [\#627](https://github.com/thoughtbot/factory_girl/issues/627)

- Testing associations fails using every FactoryGirl syntax [\#612](https://github.com/thoughtbot/factory_girl/issues/612)

- Undefined method `lint' for FactoryGirl:Module \(NoMethodError\) [\#610](https://github.com/thoughtbot/factory_girl/issues/610)

- association documentation [\#601](https://github.com/thoughtbot/factory_girl/issues/601)

**Merged pull requests:**

- Update copyright year to 2014 [\#775](https://github.com/thoughtbot/factory_girl/pull/775) ([maqnouch](https://github.com/maqnouch))

- Test against Rails 4.2 [\#769](https://github.com/thoughtbot/factory_girl/pull/769) ([joshuaclayton](https://github.com/joshuaclayton))

- Check arity to allow for Symbol\#to\_proc with dynamic attributes [\#768](https://github.com/thoughtbot/factory_girl/pull/768) ([joshuaclayton](https://github.com/joshuaclayton))

- Support Ruby 2.2 [\#767](https://github.com/thoughtbot/factory_girl/pull/767) ([joshuaclayton](https://github.com/joshuaclayton))

- Formatting [\#762](https://github.com/thoughtbot/factory_girl/pull/762) ([rubyengineer](https://github.com/rubyengineer))

- typo fix \[ci skip\] [\#761](https://github.com/thoughtbot/factory_girl/pull/761) ([georgemillo](https://github.com/georgemillo))

- Fix warnings [\#760](https://github.com/thoughtbot/factory_girl/pull/760) ([agrimm](https://github.com/agrimm))

- Mention coaching [\#759](https://github.com/thoughtbot/factory_girl/pull/759) ([jferris](https://github.com/jferris))

- Rework thoughtbot section of README [\#757](https://github.com/thoughtbot/factory_girl/pull/757) ([jferris](https://github.com/jferris))

- Introduce "About thoughtbot" section to README.md [\#756](https://github.com/thoughtbot/factory_girl/pull/756) ([cpytel](https://github.com/cpytel))

- Linting should not be the first chapter of "getting started" [\#751](https://github.com/thoughtbot/factory_girl/pull/751) ([jaredbeck](https://github.com/jaredbeck))

- Add Rubinius to Build Matrix with Allowed Failure [\#748](https://github.com/thoughtbot/factory_girl/pull/748) ([bjfish](https://github.com/bjfish))

- Cache Bundler on Travis [\#747](https://github.com/thoughtbot/factory_girl/pull/747) ([seanpdoyle](https://github.com/seanpdoyle))

- Update find\_definitions.rb [\#742](https://github.com/thoughtbot/factory_girl/pull/742) ([VFedyk](https://github.com/VFedyk))

- Updated travis.yml with ruby 2.2 [\#737](https://github.com/thoughtbot/factory_girl/pull/737) ([sivagollapalli](https://github.com/sivagollapalli))

- correct error message when stubbed reload called with transaction lock a... [\#724](https://github.com/thoughtbot/factory_girl/pull/724) ([timdiggins](https://github.com/timdiggins))

- updates getting\_started to require factory\_girl\_rails [\#723](https://github.com/thoughtbot/factory_girl/pull/723) ([meesterdude](https://github.com/meesterdude))

- Replace map.flatten with flat\_map [\#722](https://github.com/thoughtbot/factory_girl/pull/722) ([umerkulovb](https://github.com/umerkulovb))

- corrected documentation about how to generate a global sequence [\#718](https://github.com/thoughtbot/factory_girl/pull/718) ([betesh](https://github.com/betesh))

- Readme: Use an SVG badge. [\#717](https://github.com/thoughtbot/factory_girl/pull/717) ([espadrine](https://github.com/espadrine))

- Detailed list syntax method [\#709](https://github.com/thoughtbot/factory_girl/pull/709) ([nicohvi](https://github.com/nicohvi))

- Cleanup gemspec [\#708](https://github.com/thoughtbot/factory_girl/pull/708) ([igas](https://github.com/igas))

- Stop linter from crashing [\#675](https://github.com/thoughtbot/factory_girl/pull/675) ([mhenrixon](https://github.com/mhenrixon))

- Show why the factories are no longer valid when lint [\#664](https://github.com/thoughtbot/factory_girl/pull/664) ([marcocarvalho](https://github.com/marcocarvalho))

- IGNORE [\#540](https://github.com/thoughtbot/factory_girl/pull/540) ([joshuaclayton](https://github.com/joshuaclayton))

## [v4.5.0](https://github.com/thoughtbot/factory_girl/tree/v4.5.0) (2014-10-17)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v4.4.0...v4.5.0)

**Closed issues:**

- Undefined method true for ... with rails 4.2.0.beta2 [\#700](https://github.com/thoughtbot/factory_girl/issues/700)

- apply random traits in Factory [\#699](https://github.com/thoughtbot/factory_girl/issues/699)

- Newest version doesn't contain same code as github repository [\#694](https://github.com/thoughtbot/factory_girl/issues/694)

- Attributes for factories associations [\#693](https://github.com/thoughtbot/factory_girl/issues/693)

- Validation failed when calling `create` for model with `has\_many :through` [\#682](https://github.com/thoughtbot/factory_girl/issues/682)

- FactoryGirl.attributes converting enum to integer [\#680](https://github.com/thoughtbot/factory_girl/issues/680)

- How to make factories using existing associated entities by default [\#679](https://github.com/thoughtbot/factory_girl/issues/679)

- intitalize\_with with an existing record [\#678](https://github.com/thoughtbot/factory_girl/issues/678)

- Document example of gem developer providing factories in gem [\#677](https://github.com/thoughtbot/factory_girl/issues/677)

- FactoryGirl seems to ignore sequences when a dash "-" is put directly before the \#{n} [\#672](https://github.com/thoughtbot/factory_girl/issues/672)

- Problem while loading model class when there's a lib class with the same name [\#670](https://github.com/thoughtbot/factory_girl/issues/670)

- when using inheritance, factory returns parent instead of subclass [\#667](https://github.com/thoughtbot/factory_girl/issues/667)

- "method" attribute is reserved? [\#666](https://github.com/thoughtbot/factory_girl/issues/666)

- Stubbing methods before `FactoryGirl.lint'` [\#665](https://github.com/thoughtbot/factory_girl/issues/665)

- FactoryGirl.create\_list is not giving expected result [\#660](https://github.com/thoughtbot/factory_girl/issues/660)

- Transient vs Ignore [\#658](https://github.com/thoughtbot/factory_girl/issues/658)

- Factory for model with `enum` not generating correct data [\#656](https://github.com/thoughtbot/factory_girl/issues/656)

- Transient attribute with default value of {} instead defaults to nil in evaluator [\#652](https://github.com/thoughtbot/factory_girl/issues/652)

- ActiveRecord::AssociationTypeMismatch: Bla\(\#70229418436920\) expected, got Bla\(\#70229429485000\) [\#650](https://github.com/thoughtbot/factory_girl/issues/650)

- after\(:build\) callback should be triggered prior to save [\#649](https://github.com/thoughtbot/factory_girl/issues/649)

- Mock model method for FactoryGirl.lint to avoid API errors [\#647](https://github.com/thoughtbot/factory_girl/issues/647)

- Unsatisfied dependency on DatabaseCleaner, breaks Rails apps. [\#644](https://github.com/thoughtbot/factory_girl/issues/644)

- Empty array attribute not being persisted when creating new factories [\#643](https://github.com/thoughtbot/factory_girl/issues/643)

- Unique instance factories [\#642](https://github.com/thoughtbot/factory_girl/issues/642)

- Allow defining/overriding attribute default with concrete \*instance\* [\#637](https://github.com/thoughtbot/factory_girl/issues/637)

- FactoryGirl strips leading 0 off literal strings if it think they are numbers [\#632](https://github.com/thoughtbot/factory_girl/issues/632)

- FactoryGirl does not use active\_record save method when creating records? [\#629](https://github.com/thoughtbot/factory_girl/issues/629)

- Skipping a factory from being validated inside FactoryGirl.lint [\#623](https://github.com/thoughtbot/factory_girl/issues/623)

- Ambiguous documentation on `initialize\_with` behaviour [\#622](https://github.com/thoughtbot/factory_girl/issues/622)

- Running lint in spec\_helper/test\_helper vs each test suite [\#620](https://github.com/thoughtbot/factory_girl/issues/620)

- FactoryGirl.lint leaves created objects in database [\#614](https://github.com/thoughtbot/factory_girl/issues/614)

**Merged pull requests:**

- Fresh pass at displaying more detail during linting [\#707](https://github.com/thoughtbot/factory_girl/pull/707) ([joshuaclayton](https://github.com/joshuaclayton))

- Display validation errors when using FactoryGirl.lint [\#704](https://github.com/thoughtbot/factory_girl/pull/704) ([joshuaclayton](https://github.com/joshuaclayton))

- Fix compatibility typo [\#697](https://github.com/thoughtbot/factory_girl/pull/697) ([eliotsykes](https://github.com/eliotsykes))

- Adding error messages to lint output [\#692](https://github.com/thoughtbot/factory_girl/pull/692) ([jwhitmire](https://github.com/jwhitmire))

- Update GETTING\_STARTED.md [\#685](https://github.com/thoughtbot/factory_girl/pull/685) ([Bartuz](https://github.com/Bartuz))

- Replace File.exists? with File.exist? [\#669](https://github.com/thoughtbot/factory_girl/pull/669) ([tilsammans](https://github.com/tilsammans))

- fix deprecation warning on File.exists? [\#668](https://github.com/thoughtbot/factory_girl/pull/668) ([masterkain](https://github.com/masterkain))

- Reference released documentation [\#663](https://github.com/thoughtbot/factory_girl/pull/663) ([jferris](https://github.com/jferris))

- public\_send attribute assignment [\#662](https://github.com/thoughtbot/factory_girl/pull/662) ([joshuaclayton](https://github.com/joshuaclayton))

- change file name of CONTRIBUTION\_GUIDELINES.md [\#661](https://github.com/thoughtbot/factory_girl/pull/661) ([awingla](https://github.com/awingla))

- Add note regarding version, \#ignore, & \#transient [\#659](https://github.com/thoughtbot/factory_girl/pull/659) ([bendyorke](https://github.com/bendyorke))

- Minor syntax change from stub to double in factory\_spec [\#657](https://github.com/thoughtbot/factory_girl/pull/657) ([loganhasson](https://github.com/loganhasson))

- Allow list sizes to be specified as ranges. [\#655](https://github.com/thoughtbot/factory_girl/pull/655) ([whittle](https://github.com/whittle))

- Update 2.6.x's README.md [\#654](https://github.com/thoughtbot/factory_girl/pull/654) ([Bonifacio2](https://github.com/Bonifacio2))

- Selective FactoryGirl.lint [\#653](https://github.com/thoughtbot/factory_girl/pull/653) ([dredozubov](https://github.com/dredozubov))

- Rename `ignore` to `transient` [\#651](https://github.com/thoughtbot/factory_girl/pull/651) ([iwz](https://github.com/iwz))

- More specific rspec path in GETTING\_STARTED [\#648](https://github.com/thoughtbot/factory_girl/pull/648) ([shosanna](https://github.com/shosanna))

- FactoryGirl should refuse to assign to a private setter. [\#646](https://github.com/thoughtbot/factory_girl/pull/646) ([Peeja](https://github.com/Peeja))

- Improving the documentation around Factory Linting and the DatabaseCleaner class. [\#645](https://github.com/thoughtbot/factory_girl/pull/645) ([edelgado](https://github.com/edelgado))

- Allow setting of class on association [\#641](https://github.com/thoughtbot/factory_girl/pull/641) ([dwhenry](https://github.com/dwhenry))

- Syntax tweak [\#634](https://github.com/thoughtbot/factory_girl/pull/634) ([rubyengineer](https://github.com/rubyengineer))

- code example error in GETTING\_STARTED.md fix [\#633](https://github.com/thoughtbot/factory_girl/pull/633) ([evilguc](https://github.com/evilguc))

- inform the user what model and method violated the stub [\#630](https://github.com/thoughtbot/factory_girl/pull/630) ([fearoffish](https://github.com/fearoffish))

- Update documentation on using initialize\_with [\#626](https://github.com/thoughtbot/factory_girl/pull/626) ([lime](https://github.com/lime))

- Update GETTING\_STARTED.md [\#624](https://github.com/thoughtbot/factory_girl/pull/624) ([Dunnzilla](https://github.com/Dunnzilla))

- minor doco updates to make it clear we are calling factory\_girl methods [\#621](https://github.com/thoughtbot/factory_girl/pull/621) ([leriksen](https://github.com/leriksen))

- \#614 - added note about using DatabaseCleaner to wrap lint if any factory builds persist data [\#619](https://github.com/thoughtbot/factory_girl/pull/619) ([garysweaver](https://github.com/garysweaver))

- Make lint indicate factory name when factory build fails [\#618](https://github.com/thoughtbot/factory_girl/pull/618) ([garysweaver](https://github.com/garysweaver))

- Include DatabaseCleaner usage when demoing FactoryGirl.lint [\#611](https://github.com/thoughtbot/factory_girl/pull/611) ([joshuaclayton](https://github.com/joshuaclayton))

- Add instance method to evaluator, so factories can access the object being built [\#606](https://github.com/thoughtbot/factory_girl/pull/606) ([oggy](https://github.com/oggy))

## [v4.4.0](https://github.com/thoughtbot/factory_girl/tree/v4.4.0) (2014-02-11)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v4.3.0...v4.4.0)

**Closed issues:**

- Postgres Array column issue [\#605](https://github.com/thoughtbot/factory_girl/issues/605)

- Spring + FactoryGirl [\#599](https://github.com/thoughtbot/factory_girl/issues/599)

- left parenthesis getting stripped out [\#597](https://github.com/thoughtbot/factory_girl/issues/597)

- Mock up for ActiveRecord model scope [\#596](https://github.com/thoughtbot/factory_girl/issues/596)

- Race condition problem [\#595](https://github.com/thoughtbot/factory_girl/issues/595)

- saving new variables, currently not dry [\#593](https://github.com/thoughtbot/factory_girl/issues/593)

- Changelog missing entry for 4.3.0 release [\#591](https://github.com/thoughtbot/factory_girl/issues/591)

- Memory leak occurs when association method is used [\#586](https://github.com/thoughtbot/factory_girl/issues/586)

- after\_create callbacks [\#585](https://github.com/thoughtbot/factory_girl/issues/585)

- Factory girl doesn't play with default\_value\_for gem [\#584](https://github.com/thoughtbot/factory_girl/issues/584)

- Access to constructor attributes hash within dynamic attribute block? + nested association [\#583](https://github.com/thoughtbot/factory_girl/issues/583)

- how to use traits to append values to a postgres array type? [\#582](https://github.com/thoughtbot/factory_girl/issues/582)

- Attribute not set if named after global method  [\#581](https://github.com/thoughtbot/factory_girl/issues/581)

- Allow passing to 'association' custom factory traits too [\#580](https://github.com/thoughtbot/factory_girl/issues/580)

- Can't have attribute called "method" in a factory [\#579](https://github.com/thoughtbot/factory_girl/issues/579)

- Forced creating of an invalid record [\#578](https://github.com/thoughtbot/factory_girl/issues/578)

- Support for nested\_attributes [\#577](https://github.com/thoughtbot/factory_girl/issues/577)

- Factory girl and Postgres UUID attempts to insert NULL. [\#576](https://github.com/thoughtbot/factory_girl/issues/576)

- update\_attribute unable to modify foreign key [\#574](https://github.com/thoughtbot/factory_girl/issues/574)

- Global After\_Create Methods [\#571](https://github.com/thoughtbot/factory_girl/issues/571)

- Many to Many / :has\_many :through [\#543](https://github.com/thoughtbot/factory_girl/issues/543)

- Ensure rdoc.info has the latest docs [\#512](https://github.com/thoughtbot/factory_girl/issues/512)

**Merged pull requests:**

- Add FactoryGirl.lint to ensure all factories are valid [\#609](https://github.com/thoughtbot/factory_girl/pull/609) ([joshuaclayton](https://github.com/joshuaclayton))

- Instructions to include Syntax::Methods in Spinach [\#607](https://github.com/thoughtbot/factory_girl/pull/607) ([cibernox](https://github.com/cibernox))

- added MiniTest config example for notification subscription [\#603](https://github.com/thoughtbot/factory_girl/pull/603) ([garysweaver](https://github.com/garysweaver))

- Move away from FactoryGirl to factory\_girl in docs [\#602](https://github.com/thoughtbot/factory_girl/pull/602) ([dgalarza](https://github.com/dgalarza))

- Add Ruby 2.1.0 to .travis.yml [\#598](https://github.com/thoughtbot/factory_girl/pull/598) ([salimane](https://github.com/salimane))

- Remove references to the closed mailing list [\#594](https://github.com/thoughtbot/factory_girl/pull/594) ([jferris](https://github.com/jferris))

- Prefer the shorter syntax [\#590](https://github.com/thoughtbot/factory_girl/pull/590) ([cpytel](https://github.com/cpytel))

- Fix memory leak: do not add trait duplications to @defined\_traits [\#588](https://github.com/thoughtbot/factory_girl/pull/588) ([greyblake](https://github.com/greyblake))

- Added space for curly brackets to follow the Thoughtbot style guide for the Getting\_Started.md [\#587](https://github.com/thoughtbot/factory_girl/pull/587) ([jmoon90](https://github.com/jmoon90))

## [v4.3.0](https://github.com/thoughtbot/factory_girl/tree/v4.3.0) (2013-11-04)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v4.2.0...v4.3.0)

**Closed issues:**

- belongs\_to undefined method [\#568](https://github.com/thoughtbot/factory_girl/issues/568)

- counter\_cache seems to be duplicating [\#566](https://github.com/thoughtbot/factory_girl/issues/566)

- Allow return values from 'to\_create' [\#565](https://github.com/thoughtbot/factory_girl/issues/565)

- Add possibility to include helper methods into FactoryGirl to be able to use them on factory definition [\#564](https://github.com/thoughtbot/factory_girl/issues/564)

- Error creating association list [\#562](https://github.com/thoughtbot/factory_girl/issues/562)

- Foreign key is not saved [\#561](https://github.com/thoughtbot/factory_girl/issues/561)

- Factory girl vs postgres schemas vs set\_table\_name in models [\#558](https://github.com/thoughtbot/factory_girl/issues/558)

- Factories do not respect foreign\_key defined in associations [\#557](https://github.com/thoughtbot/factory_girl/issues/557)

- stringish ids are nullified [\#556](https://github.com/thoughtbot/factory_girl/issues/556)

- build\_stubbed vs. create with Rails 3.2.14/4.0.0 [\#555](https://github.com/thoughtbot/factory_girl/issues/555)

- Getting: TypeError: Cannot visit FactoryGirl::Declaration::Implicit [\#554](https://github.com/thoughtbot/factory_girl/issues/554)

- created unintentionally  [\#553](https://github.com/thoughtbot/factory_girl/issues/553)

- Have attributes available within after/before callbacks [\#552](https://github.com/thoughtbot/factory_girl/issues/552)

- Using factories outside of an engine [\#551](https://github.com/thoughtbot/factory_girl/issues/551)

- Problems with factory\_girl and has\_many / belongs\_to associations [\#549](https://github.com/thoughtbot/factory_girl/issues/549)

- attr\_accessible still invoked when attribute passed as override [\#548](https://github.com/thoughtbot/factory_girl/issues/548)

- How To Explicitly Define Factory Attribute With Name 'sequence' [\#547](https://github.com/thoughtbot/factory_girl/issues/547)

- datamapper: factory for models descending from another one [\#545](https://github.com/thoughtbot/factory_girl/issues/545)

- FactoryGirl with Mongoid: Not generate id when id is rewrite. [\#544](https://github.com/thoughtbot/factory_girl/issues/544)

- Memory Leak in FactoryGirl::Declaration::Implicit ? [\#542](https://github.com/thoughtbot/factory_girl/issues/542)

- Time changes when using create\_list [\#541](https://github.com/thoughtbot/factory_girl/issues/541)

- Factory Girl creates Faker duplicates if called in describe blocks [\#538](https://github.com/thoughtbot/factory_girl/issues/538)

- Fully namespaced factories \(for engine support\) [\#537](https://github.com/thoughtbot/factory_girl/issues/537)

- FactoryGirl.create doesn't know how to link objects w/ multiple foreign keys [\#536](https://github.com/thoughtbot/factory_girl/issues/536)

- Association not being set up [\#535](https://github.com/thoughtbot/factory_girl/issues/535)

- has\_secure\_password user reload [\#534](https://github.com/thoughtbot/factory_girl/issues/534)

- question: What is the best way to test factories where the model has belongs\_to :owner associations and validates presence of that owner? [\#533](https://github.com/thoughtbot/factory_girl/issues/533)

- Ability to overwrite a property of association [\#532](https://github.com/thoughtbot/factory_girl/issues/532)

- Macro like let to do a create.  [\#531](https://github.com/thoughtbot/factory_girl/issues/531)

- Re-Using factories from inside an engine?! [\#530](https://github.com/thoughtbot/factory_girl/issues/530)

- build/create methods not available/malfunctioning in dynamic attribute scope [\#529](https://github.com/thoughtbot/factory_girl/issues/529)

- Is it possible to include a trait by default in a factory? [\#528](https://github.com/thoughtbot/factory_girl/issues/528)

- Is it possible to pass an argument into a trait? [\#527](https://github.com/thoughtbot/factory_girl/issues/527)

- block should run before save on create method [\#526](https://github.com/thoughtbot/factory_girl/issues/526)

- Accessing transient attributes in callback [\#525](https://github.com/thoughtbot/factory_girl/issues/525)

- Show examples of \(embeds\_many\) association when using FactoryGirl with Mongoid. [\#524](https://github.com/thoughtbot/factory_girl/issues/524)

- ActiveRecord::RecordInvalid:Validation [\#523](https://github.com/thoughtbot/factory_girl/issues/523)

- Passing certain attributes to \#build or \#create clears out other factory-defined attributes [\#522](https://github.com/thoughtbot/factory_girl/issues/522)

- FactoryGirl.create returns an instance with the belongs\_to\_association flag @updated set to true [\#520](https://github.com/thoughtbot/factory_girl/issues/520)

- Catch-22 in circular validation [\#519](https://github.com/thoughtbot/factory_girl/issues/519)

- attributes\_for and callbacks [\#517](https://github.com/thoughtbot/factory_girl/issues/517)

- add shared method to customize factories [\#516](https://github.com/thoughtbot/factory_girl/issues/516)

- create a "has-one" association [\#514](https://github.com/thoughtbot/factory_girl/issues/514)

- Undefined method `singleton\_method\_added=` instantiating ActiveRecord class [\#513](https://github.com/thoughtbot/factory_girl/issues/513)

- ActiveRecord 4 deprecation warnings [\#510](https://github.com/thoughtbot/factory_girl/issues/510)

- GETTING\_STARTED.md bug [\#509](https://github.com/thoughtbot/factory_girl/issues/509)

- double records when using nested attributes and virtual attribute [\#508](https://github.com/thoughtbot/factory_girl/issues/508)

- Using association.create! on factory\_girl created objects [\#507](https://github.com/thoughtbot/factory_girl/issues/507)

- Rails 2.3.18 [\#506](https://github.com/thoughtbot/factory_girl/issues/506)

- Using FactoryGirl Callback with Draper not working [\#505](https://github.com/thoughtbot/factory_girl/issues/505)

- Factory for a child join model? [\#504](https://github.com/thoughtbot/factory_girl/issues/504)

- FactoryGirl and Update Validations [\#503](https://github.com/thoughtbot/factory_girl/issues/503)

- Use FactoryGirl with hstore [\#502](https://github.com/thoughtbot/factory_girl/issues/502)

- Association with different foreign keys [\#501](https://github.com/thoughtbot/factory_girl/issues/501)

- Applying FactoryGirl trait to embedded objects [\#500](https://github.com/thoughtbot/factory_girl/issues/500)

- DataMapper's :save callback hook not getting called from FactoryGirl-created instances [\#499](https://github.com/thoughtbot/factory_girl/issues/499)

- Factory Girl - stack level too deep [\#498](https://github.com/thoughtbot/factory_girl/issues/498)

- FactoryGirl is ignoring attr\_accessible [\#496](https://github.com/thoughtbot/factory_girl/issues/496)

- Requiring a non-existent file in a factory definition silently fails [\#495](https://github.com/thoughtbot/factory_girl/issues/495)

- How to avoid forceful creation of empty associated record? [\#494](https://github.com/thoughtbot/factory_girl/issues/494)

- undefined method `peek' for 0:Fixnum [\#493](https://github.com/thoughtbot/factory_girl/issues/493)

- Cannot access RSpec metadata from a Factory definition [\#490](https://github.com/thoughtbot/factory_girl/issues/490)

- Factory Girl 4.2.0 doesn't install w/ via bundle [\#489](https://github.com/thoughtbot/factory_girl/issues/489)

- Using factory\_girl into a mounted engine throws ArgumentError: Factory not registered [\#488](https://github.com/thoughtbot/factory_girl/issues/488)

- Double-created records with polymorphic association [\#487](https://github.com/thoughtbot/factory_girl/issues/487)

- DuplicateDefinitionError for factory with "\_localization" suffix [\#485](https://github.com/thoughtbot/factory_girl/issues/485)

- Testing all Factories \(with RSpec\) twice in a row gives uniqueness error [\#484](https://github.com/thoughtbot/factory_girl/issues/484)

- build & build\_stubbed skip "before\_validation" calls? [\#483](https://github.com/thoughtbot/factory_girl/issues/483)

- FactoryGirl doesn't handle array: true [\#480](https://github.com/thoughtbot/factory_girl/issues/480)

- Using through associations in hooks [\#479](https://github.com/thoughtbot/factory_girl/issues/479)

- Undefined method error when creating new instances [\#467](https://github.com/thoughtbot/factory_girl/issues/467)

**Merged pull requests:**

- Update GETTING\_STARTED.md [\#575](https://github.com/thoughtbot/factory_girl/pull/575) ([ebbflowgo](https://github.com/ebbflowgo))

- Add more helpful list methods [\#573](https://github.com/thoughtbot/factory_girl/pull/573) ([joshuaclayton](https://github.com/joshuaclayton))

- Fixes typos in GETTING\_STARTED.md [\#572](https://github.com/thoughtbot/factory_girl/pull/572) ([tadp](https://github.com/tadp))

- remove deprecation warnings [\#570](https://github.com/thoughtbot/factory_girl/pull/570) ([PlugIN73](https://github.com/PlugIN73))

- make load gem more lazy [\#569](https://github.com/thoughtbot/factory_girl/pull/569) ([PlugIN73](https://github.com/PlugIN73))

- replaced eager\_load by lazy\_load [\#567](https://github.com/thoughtbot/factory_girl/pull/567) ([mrsutter](https://github.com/mrsutter))

- Update GETTING\_STARTED.md [\#563](https://github.com/thoughtbot/factory_girl/pull/563) ([kddeisz](https://github.com/kddeisz))

- adds missing highlighting directives [\#560](https://github.com/thoughtbot/factory_girl/pull/560) ([djbender](https://github.com/djbender))

- test [\#559](https://github.com/thoughtbot/factory_girl/pull/559) ([xylinq](https://github.com/xylinq))

- Update dependencies including ActiveRecord which was locked at 1.6.0 [\#550](https://github.com/thoughtbot/factory_girl/pull/550) ([joshuaclayton](https://github.com/joshuaclayton))

- Fix factory named camel case string [\#546](https://github.com/thoughtbot/factory_girl/pull/546) ([mtsmfm](https://github.com/mtsmfm))

- Update appraisals [\#539](https://github.com/thoughtbot/factory_girl/pull/539) ([derekprior](https://github.com/derekprior))

- Add link to LICENSE in README [\#521](https://github.com/thoughtbot/factory_girl/pull/521) ([chrishunt](https://github.com/chrishunt))

- Add an example of a trait used within a trait. [\#518](https://github.com/thoughtbot/factory_girl/pull/518) ([olivierlacan](https://github.com/olivierlacan))

- Test ageinst ruby2.0 in travis-ci [\#515](https://github.com/thoughtbot/factory_girl/pull/515) ([sanemat](https://github.com/sanemat))

- Fix short syntax [\#511](https://github.com/thoughtbot/factory_girl/pull/511) ([releu](https://github.com/releu))

- bugfix in docs for creating association \[ci skip\] [\#497](https://github.com/thoughtbot/factory_girl/pull/497) ([deepak](https://github.com/deepak))

- change reference from 'next' to 'generate' [\#492](https://github.com/thoughtbot/factory_girl/pull/492) ([dpickett](https://github.com/dpickett))

- probable typo - missing interpolation \# [\#491](https://github.com/thoughtbot/factory_girl/pull/491) ([dpickett](https://github.com/dpickett))

- Add global callbacks [\#486](https://github.com/thoughtbot/factory_girl/pull/486) ([joshuaclayton](https://github.com/joshuaclayton))

- add license information to the gemspec [\#482](https://github.com/thoughtbot/factory_girl/pull/482) ([jordimassaguerpla](https://github.com/jordimassaguerpla))

- Custom global callbacks [\#481](https://github.com/thoughtbot/factory_girl/pull/481) ([DeTeam](https://github.com/DeTeam))

## [v4.2.0](https://github.com/thoughtbot/factory_girl/tree/v4.2.0) (2013-01-18)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.6.2...v4.2.0)

**Closed issues:**

- FactoryGirl has\_many :through relationship broken in Rails 3.2.11 [\#474](https://github.com/thoughtbot/factory_girl/issues/474)

- NoMethodError .to\_i when upgrading to Rails 3.2.11 [\#473](https://github.com/thoughtbot/factory_girl/issues/473)

- undefined method 'to\_sym' for FactoryGirl::Declaration::Implicit [\#472](https://github.com/thoughtbot/factory_girl/issues/472)

- ID not being set when model sets self.primary\_key [\#471](https://github.com/thoughtbot/factory_girl/issues/471)

- sprintf in sequence Proc causes error [\#466](https://github.com/thoughtbot/factory_girl/issues/466)

- Unable to use a trait in an association [\#465](https://github.com/thoughtbot/factory_girl/issues/465)

- Sequence: Lazy association attribute not properly evaluated [\#464](https://github.com/thoughtbot/factory_girl/issues/464)

- Unable to define factory for model whose name contains "\_attribute" [\#462](https://github.com/thoughtbot/factory_girl/issues/462)

- no image handler error  while using factory girl  with paper clip .............. [\#461](https://github.com/thoughtbot/factory_girl/issues/461)

- Mass-assignment of attributes in attributes\_for [\#460](https://github.com/thoughtbot/factory_girl/issues/460)

- stuck in the start of  learning factory\_girl \(NoMethodError: undefined method `symbolize\_keys' /\) [\#459](https://github.com/thoughtbot/factory_girl/issues/459)

- Traits as attributes with transient attributes [\#457](https://github.com/thoughtbot/factory_girl/issues/457)

- unable to use a factory with some names? [\#456](https://github.com/thoughtbot/factory_girl/issues/456)

- DSL improvement suggestions [\#455](https://github.com/thoughtbot/factory_girl/issues/455)

- creation of dependent model fails [\#454](https://github.com/thoughtbot/factory_girl/issues/454)

- can't assign an id using build\_stubbed strategy [\#451](https://github.com/thoughtbot/factory_girl/issues/451)

- associations not being returned with attributes\_for\(:factory\) [\#450](https://github.com/thoughtbot/factory_girl/issues/450)

- Factories for database views [\#449](https://github.com/thoughtbot/factory_girl/issues/449)

- Maintain a 3.6.x branch for backwards compatibility [\#446](https://github.com/thoughtbot/factory_girl/issues/446)

- Have a column equal exists function name  [\#439](https://github.com/thoughtbot/factory_girl/issues/439)

- build and create methods fail to set custom ids for Mongoid 3 [\#438](https://github.com/thoughtbot/factory_girl/issues/438)

**Merged pull requests:**

- Bump version to 4.2.0 [\#478](https://github.com/thoughtbot/factory_girl/pull/478) ([joshuaclayton](https://github.com/joshuaclayton))

- Remove some warnings when running RUBYOPT=-w rake [\#477](https://github.com/thoughtbot/factory_girl/pull/477) ([joshuaclayton](https://github.com/joshuaclayton))

- Update mocha version dependency and require mocha/api [\#476](https://github.com/thoughtbot/factory_girl/pull/476) ([joshuaclayton](https://github.com/joshuaclayton))

- Evaluate sequences within the context of the Evaluator when possible [\#475](https://github.com/thoughtbot/factory_girl/pull/475) ([joshuaclayton](https://github.com/joshuaclayton))

- Fix deprecation warning from Mocha [\#470](https://github.com/thoughtbot/factory_girl/pull/470) ([Phill](https://github.com/Phill))

- Match build\_stubbed's created\_at type to ActiveRecord [\#469](https://github.com/thoughtbot/factory_girl/pull/469) ([aripollak](https://github.com/aripollak))

- Use factory\_girl to generate seed data [\#468](https://github.com/thoughtbot/factory_girl/pull/468) ([innatewonderer](https://github.com/innatewonderer))

- Reduced warnings [\#463](https://github.com/thoughtbot/factory_girl/pull/463) ([ToadJamb](https://github.com/ToadJamb))

- Run travis CI against ruby 2 dev [\#453](https://github.com/thoughtbot/factory_girl/pull/453) ([calebthompson](https://github.com/calebthompson))

- Allow setting id for build\_stubbed objects [\#452](https://github.com/thoughtbot/factory_girl/pull/452) ([joshuaclayton](https://github.com/joshuaclayton))

- Fix association reference in example [\#448](https://github.com/thoughtbot/factory_girl/pull/448) ([stve](https://github.com/stve))

- Re: \#431 -- Added a note about `strategy: :build` [\#432](https://github.com/thoughtbot/factory_girl/pull/432) ([hosamaly](https://github.com/hosamaly))

## [v3.6.2](https://github.com/thoughtbot/factory_girl/tree/v3.6.2) (2012-10-24)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v4.1.0...v3.6.2)

**Closed issues:**

- build\_list after after\(:build\) [\#447](https://github.com/thoughtbot/factory_girl/issues/447)

- FactoryGirl interferes with the create action when using controller inheritance. [\#443](https://github.com/thoughtbot/factory_girl/issues/443)

- FactoryGirl::Declaration subclass == method assumes object of same type [\#440](https://github.com/thoughtbot/factory_girl/issues/440)

- FactoryGirl attempts to create a polymorphically associated record even though it is already supplied in the options hash [\#436](https://github.com/thoughtbot/factory_girl/issues/436)

**Merged pull requests:**

- Modified define\_list\_strategy\_method to accept and use a block. [\#445](https://github.com/thoughtbot/factory_girl/pull/445) ([bbugh](https://github.com/bbugh))

- Typos fix [\#444](https://github.com/thoughtbot/factory_girl/pull/444) ([pjg](https://github.com/pjg))

- Autogenerate with simple sequences [\#442](https://github.com/thoughtbot/factory_girl/pull/442) ([HugoLnx](https://github.com/HugoLnx))

- Add MiniTest syntax methods to GETTING\_STARTED [\#441](https://github.com/thoughtbot/factory_girl/pull/441) ([phlipper](https://github.com/phlipper))

- Refactor spec to avoid a general fixture [\#437](https://github.com/thoughtbot/factory_girl/pull/437) ([jferris](https://github.com/jferris))

## [v4.1.0](https://github.com/thoughtbot/factory_girl/tree/v4.1.0) (2012-09-11)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v4.0.0...v4.1.0)

**Closed issues:**

- Factory\_girl [\#434](https://github.com/thoughtbot/factory_girl/issues/434)

- How can I get allready asigned parameter? [\#433](https://github.com/thoughtbot/factory_girl/issues/433)

- Association :build strategy doesn't work on implicit associations [\#431](https://github.com/thoughtbot/factory_girl/issues/431)

- Yard throwing errors on 4.0.0 update [\#430](https://github.com/thoughtbot/factory_girl/issues/430)

- Deprecation Warning [\#429](https://github.com/thoughtbot/factory_girl/issues/429)

- Factory not registered error depending on names of factory files [\#428](https://github.com/thoughtbot/factory_girl/issues/428)

- FactoryGirl DSL clashing with Rake DSL? [\#427](https://github.com/thoughtbot/factory_girl/issues/427)

- Dependent Associations [\#426](https://github.com/thoughtbot/factory_girl/issues/426)

- "uninitialized constant Factory \(NameError\)" occurs [\#425](https://github.com/thoughtbot/factory_girl/issues/425)

- Associations and Nested Factories [\#424](https://github.com/thoughtbot/factory_girl/issues/424)

- Factory Girl behaves differently in after\_initialized than ActiveRecord [\#422](https://github.com/thoughtbot/factory_girl/issues/422)

- Integrate with rails generators [\#421](https://github.com/thoughtbot/factory_girl/issues/421)

- Validation failed: Username has already been taken, Email has already been taken [\#419](https://github.com/thoughtbot/factory_girl/issues/419)

- Factory'd models cannot be Rails.cache'd [\#417](https://github.com/thoughtbot/factory_girl/issues/417)

**Merged pull requests:**

- Support binding a block to multiple callbacks [\#435](https://github.com/thoughtbot/factory_girl/pull/435) ([joshuaclayton](https://github.com/joshuaclayton))

- quick doc fix: replaced reference to "stub" build strategy [\#423](https://github.com/thoughtbot/factory_girl/pull/423) ([eostrom](https://github.com/eostrom))

- Document how to use traits for associations [\#420](https://github.com/thoughtbot/factory_girl/pull/420) ([ktheory](https://github.com/ktheory))

## [v4.0.0](https://github.com/thoughtbot/factory_girl/tree/v4.0.0) (2012-08-03)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v4.0.0.rc1...v4.0.0)

## [v4.0.0.rc1](https://github.com/thoughtbot/factory_girl/tree/v4.0.0.rc1) (2012-08-02)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.6.1...v4.0.0.rc1)

## [v3.6.1](https://github.com/thoughtbot/factory_girl/tree/v3.6.1) (2012-08-02)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.6.0...v3.6.1)

**Closed issues:**

- An attributes\_for method that builds associations and also returns their ID's [\#408](https://github.com/thoughtbot/factory_girl/issues/408)

**Merged pull requests:**

- Prepping for FactoryGirl 4.0 [\#418](https://github.com/thoughtbot/factory_girl/pull/418) ([joshuaclayton](https://github.com/joshuaclayton))

## [v3.6.0](https://github.com/thoughtbot/factory_girl/tree/v3.6.0) (2012-07-27)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.5.0...v3.6.0)

**Closed issues:**

- Problem calling global methods\(?\) [\#416](https://github.com/thoughtbot/factory_girl/issues/416)

- Following Wiki's instructions, got deprecation warning [\#415](https://github.com/thoughtbot/factory_girl/issues/415)

- error with jruby [\#414](https://github.com/thoughtbot/factory_girl/issues/414)

- How to get the same cached parent object for several child instances? [\#413](https://github.com/thoughtbot/factory_girl/issues/413)

- Creating a Date attribute becomes a Time [\#411](https://github.com/thoughtbot/factory_girl/issues/411)

- Model Callbacks not Firing [\#410](https://github.com/thoughtbot/factory_girl/issues/410)

- many records ? [\#406](https://github.com/thoughtbot/factory_girl/issues/406)

- Rubinius? [\#405](https://github.com/thoughtbot/factory_girl/issues/405)

- Factory\_girl 3.5.0 with rails 3.0.5 [\#404](https://github.com/thoughtbot/factory_girl/issues/404)

- Possible jRuby support? [\#402](https://github.com/thoughtbot/factory_girl/issues/402)

- Deprecation warnings don't show location of deprecated code [\#401](https://github.com/thoughtbot/factory_girl/issues/401)

- uninitialized constant User [\#400](https://github.com/thoughtbot/factory_girl/issues/400)

- Forgery + FactoryGirl Definition Proxy =\> undefined method `user\_name' for \#<FactoryGirl::Declaration::Static:...\> [\#399](https://github.com/thoughtbot/factory_girl/issues/399)

- Using \#build\_stubbed with Mongoid [\#398](https://github.com/thoughtbot/factory_girl/issues/398)

- "Record is invalid" could give some more details [\#397](https://github.com/thoughtbot/factory_girl/issues/397)

- Missing factories lead to "step not existing" in Cucumber when using FG's built-in steps [\#396](https://github.com/thoughtbot/factory_girl/issues/396)

- How to pass traits to \#association method when defining a factory? [\#395](https://github.com/thoughtbot/factory_girl/issues/395)

- Association with multiple overrides causing ArgumentError [\#392](https://github.com/thoughtbot/factory_girl/issues/392)

**Merged pull requests:**

- Fix FactoryGirl naming convention [\#412](https://github.com/thoughtbot/factory_girl/pull/412) ([sikachu](https://github.com/sikachu))

- Update master [\#409](https://github.com/thoughtbot/factory_girl/pull/409) ([artemk](https://github.com/artemk))

- Allows one to pass traits on associations declarations [\#407](https://github.com/thoughtbot/factory_girl/pull/407) ([fabiokr](https://github.com/fabiokr))

- Adding JRuby support for FactoryGirl. [\#403](https://github.com/thoughtbot/factory_girl/pull/403) ([ifesdjeen](https://github.com/ifesdjeen))

## [v3.5.0](https://github.com/thoughtbot/factory_girl/tree/v3.5.0) (2012-06-22)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.6.5...v3.5.0)

## [v2.6.5](https://github.com/thoughtbot/factory_girl/tree/v2.6.5) (2012-06-22)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.4.2...v2.6.5)

**Merged pull requests:**

- Easier usage in non-active record environment [\#394](https://github.com/thoughtbot/factory_girl/pull/394) ([maxmeyer](https://github.com/maxmeyer))

- Allow created\_at to be set when using build\_stubbed [\#390](https://github.com/thoughtbot/factory_girl/pull/390) ([mguterl](https://github.com/mguterl))

## [v3.4.2](https://github.com/thoughtbot/factory_girl/tree/v3.4.2) (2012-06-20)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.4.1...v3.4.2)

**Closed issues:**

- Callback defined in a trait and used by a subfactory is called twice [\#393](https://github.com/thoughtbot/factory_girl/issues/393)

- Missing documentation on how to require FactoryGirl [\#391](https://github.com/thoughtbot/factory_girl/issues/391)

## [v3.4.1](https://github.com/thoughtbot/factory_girl/tree/v3.4.1) (2012-06-18)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.4.0...v3.4.1)

**Closed issues:**

- Reuse created factories \(caching\) [\#389](https://github.com/thoughtbot/factory_girl/issues/389)

- after\(:create\) or after\_create [\#388](https://github.com/thoughtbot/factory_girl/issues/388)

## [v3.4.0](https://github.com/thoughtbot/factory_girl/tree/v3.4.0) (2012-06-11)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.3.0...v3.4.0)

**Closed issues:**

- Won't install on Ruby 1.9.3-p194 [\#387](https://github.com/thoughtbot/factory_girl/issues/387)

- Fixture\_file\_upload problems [\#385](https://github.com/thoughtbot/factory_girl/issues/385)

- Callbacks Error [\#384](https://github.com/thoughtbot/factory_girl/issues/384)

- Using factories having multiple associations to the same model [\#382](https://github.com/thoughtbot/factory_girl/issues/382)

- Sequence SyntaxRunner error [\#381](https://github.com/thoughtbot/factory_girl/issues/381)

- Attributes used within to\_initialize should not be subsequently assigned after the object has been instantiated [\#345](https://github.com/thoughtbot/factory_girl/issues/345)

- I should be able to have access to all public attributes \(as a hash\) within the initialize\_with block so I can pass it directly to the constructor [\#344](https://github.com/thoughtbot/factory_girl/issues/344)

**Merged pull requests:**

- Allow to use AR class names as arguments to create, build etc [\#386](https://github.com/thoughtbot/factory_girl/pull/386) ([ineu](https://github.com/ineu))

- Optionally don't duplicate assignment in initialize\_with [\#383](https://github.com/thoughtbot/factory_girl/pull/383) ([joshuaclayton](https://github.com/joshuaclayton))

- Support for xml-serialization [\#380](https://github.com/thoughtbot/factory_girl/pull/380) ([danielfrey](https://github.com/danielfrey))

- modified Sequence to accept Enumerators [\#378](https://github.com/thoughtbot/factory_girl/pull/378) ([spartan-developer](https://github.com/spartan-developer))

## [v3.3.0](https://github.com/thoughtbot/factory_girl/tree/v3.3.0) (2012-05-13)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.2.0...v3.3.0)

**Closed issues:**

- Associated object changes \(randomly?\) [\#379](https://github.com/thoughtbot/factory_girl/issues/379)

- Fix messages for deprecated syntaxes [\#375](https://github.com/thoughtbot/factory_girl/issues/375)

- FactoryGirl: Trouble on using the 'after\_update' callback method [\#373](https://github.com/thoughtbot/factory_girl/issues/373)

- Support alternative ORMs \(DataMapper\) [\#372](https://github.com/thoughtbot/factory_girl/issues/372)

- Create {strategy}\_list methods for all strategies [\#370](https://github.com/thoughtbot/factory_girl/issues/370)

- No way to create associated object when a validation requires its presence [\#369](https://github.com/thoughtbot/factory_girl/issues/369)

- Invalid gem spec [\#368](https://github.com/thoughtbot/factory_girl/issues/368)

- First two unit tests in spec/acceptance/activesupport\_instrumentation\_spec.rb fail on fresh checkout [\#367](https://github.com/thoughtbot/factory_girl/issues/367)

- FactoryGirl::Syntax::Methods does not work with mailer specs [\#365](https://github.com/thoughtbot/factory_girl/issues/365)

- I should be able to define before\_block and after\_block callbacks, with optional on: :build or on: :create modifiers. [\#364](https://github.com/thoughtbot/factory_girl/issues/364)

- Objects not found in database but have an id [\#363](https://github.com/thoughtbot/factory_girl/issues/363)

- Writing arbitrary attributes on a model is deprecated. [\#362](https://github.com/thoughtbot/factory_girl/issues/362)

- attributes\_for should honor associations defined in the factory [\#359](https://github.com/thoughtbot/factory_girl/issues/359)

- I should be able to define to\_initialize \(or whatever it is\) for all factories [\#342](https://github.com/thoughtbot/factory_girl/issues/342)

- I should be able to define to\_create \(or skip\_create\) for all factories defined [\#341](https://github.com/thoughtbot/factory_girl/issues/341)

**Merged pull requests:**

- Fix initialize\_with to work correctly from traits [\#377](https://github.com/thoughtbot/factory_girl/pull/377) ([joshuaclayton](https://github.com/joshuaclayton))

- Fix to\_create within traits [\#376](https://github.com/thoughtbot/factory_girl/pull/376) ([joshuaclayton](https://github.com/joshuaclayton))

- Transient attributes and cucumber step definitions [\#374](https://github.com/thoughtbot/factory_girl/pull/374) ([MitinPavel](https://github.com/MitinPavel))

- Support \*\_list for all \(including custom\) strategies [\#371](https://github.com/thoughtbot/factory_girl/pull/371) ([joshuaclayton](https://github.com/joshuaclayton))

- Step definitions generated by factories can create instance variables [\#366](https://github.com/thoughtbot/factory_girl/pull/366) ([chrisbloom7](https://github.com/chrisbloom7))

## [v3.2.0](https://github.com/thoughtbot/factory_girl/tree/v3.2.0) (2012-04-24)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.1.1...v3.2.0)

**Closed issues:**

- Feature request: trait inheritance [\#360](https://github.com/thoughtbot/factory_girl/issues/360)

- Issueish: Can't find an upgrade script to remove deprecated syntax \(sample script in here\) [\#357](https://github.com/thoughtbot/factory_girl/issues/357)

- Allow users to access syntax methods from dynamic attributes [\#355](https://github.com/thoughtbot/factory_girl/issues/355)

- Model.save reloads original attributes [\#352](https://github.com/thoughtbot/factory_girl/issues/352)

- FactoryGirl seems to modify hashes I'm passing [\#351](https://github.com/thoughtbot/factory_girl/issues/351)

- Save instances with random ids? [\#350](https://github.com/thoughtbot/factory_girl/issues/350)

- If an attribute has the same name of the model, FactoryGirl raises an error. [\#349](https://github.com/thoughtbot/factory_girl/issues/349)

- Tag v3.1.1. [\#348](https://github.com/thoughtbot/factory_girl/issues/348)

- undefined method `add\_observer' [\#347](https://github.com/thoughtbot/factory_girl/issues/347)

- Allow users to call `new` without declaring the class in the initialize\_with block [\#343](https://github.com/thoughtbot/factory_girl/issues/343)

- Allow skipping create by calling `skip\_create` [\#340](https://github.com/thoughtbot/factory_girl/issues/340)

**Merged pull requests:**

- Use ActiveSupport::Notifications for pub/sub of factory usage [\#361](https://github.com/thoughtbot/factory_girl/pull/361) ([joshuaclayton](https://github.com/joshuaclayton))

- Allow strategies be registered [\#358](https://github.com/thoughtbot/factory_girl/pull/358) ([joshuaclayton](https://github.com/joshuaclayton))

- Allow FactoryGirl::Syntax::Methods be called inside dynamic attributes [\#356](https://github.com/thoughtbot/factory_girl/pull/356) ([joshuaclayton](https://github.com/joshuaclayton))

- Tests on integration with Cucumber [\#354](https://github.com/thoughtbot/factory_girl/pull/354) ([MitinPavel](https://github.com/MitinPavel))

- fix typo in GETTING\_STARTED [\#353](https://github.com/thoughtbot/factory_girl/pull/353) ([mark-rushakoff](https://github.com/mark-rushakoff))

## [v3.1.1](https://github.com/thoughtbot/factory_girl/tree/v3.1.1) (2012-04-17)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.1.0...v3.1.1)

**Merged pull requests:**

- Refactor strategies [\#346](https://github.com/thoughtbot/factory_girl/pull/346) ([joshuaclayton](https://github.com/joshuaclayton))

- Feature: more customizable sequences aka Arrays, Ranges and Stuff  [\#339](https://github.com/thoughtbot/factory_girl/pull/339) ([ricogallo](https://github.com/ricogallo))

## [v3.1.0](https://github.com/thoughtbot/factory_girl/tree/v3.1.0) (2012-04-06)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.0.0...v3.1.0)

**Closed issues:**

- Trait not registered [\#335](https://github.com/thoughtbot/factory_girl/issues/335)

- Rename Changelog to NEWS [\#333](https://github.com/thoughtbot/factory_girl/issues/333)

- No issue [\#331](https://github.com/thoughtbot/factory_girl/issues/331)

- \[feature\] Please add aliases to sequences [\#330](https://github.com/thoughtbot/factory_girl/issues/330)

- Deprecation warnings [\#328](https://github.com/thoughtbot/factory_girl/issues/328)

- Specify \#to\_create block globally? [\#327](https://github.com/thoughtbot/factory_girl/issues/327)

- Add supported Ruby versions to README [\#324](https://github.com/thoughtbot/factory_girl/issues/324)

**Merged pull requests:**

- Feature: more customizable sequences aka Arrays, Ranges and Enumerators [\#338](https://github.com/thoughtbot/factory_girl/pull/338) ([ricogallo](https://github.com/ricogallo))

- Feature: more customizable sequences aka Arrays, Ranges and Stuff [\#337](https://github.com/thoughtbot/factory_girl/pull/337) ([ricogallo](https://github.com/ricogallo))

- Sequence aliases [\#336](https://github.com/thoughtbot/factory_girl/pull/336) ([joshuaclayton](https://github.com/joshuaclayton))

- Now supports aliases of sequence via optional options hash :aliases [\#334](https://github.com/thoughtbot/factory_girl/pull/334) ([kristianmandrup](https://github.com/kristianmandrup))

- sequence can now have multiple aliases [\#332](https://github.com/thoughtbot/factory_girl/pull/332) ([kristianmandrup](https://github.com/kristianmandrup))

- Fix name of FactoryGirl::Syntax::Methods module in GETTING\_STARTED.md [\#329](https://github.com/thoughtbot/factory_girl/pull/329) ([subelsky](https://github.com/subelsky))

- use AS deprecation warn, silence deprecations in specs [\#326](https://github.com/thoughtbot/factory_girl/pull/326) ([nashby](https://github.com/nashby))

- use singleton\_class method from ruby 1.9 [\#325](https://github.com/thoughtbot/factory_girl/pull/325) ([nashby](https://github.com/nashby))

- Added a before\_create callback [\#323](https://github.com/thoughtbot/factory_girl/pull/323) ([arehberg](https://github.com/arehberg))

- Make step definitions more ORM agnostic by preferring .attribute\_names [\#313](https://github.com/thoughtbot/factory_girl/pull/313) ([cgriego](https://github.com/cgriego))

## [v3.0.0](https://github.com/thoughtbot/factory_girl/tree/v3.0.0) (2012-03-23)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v3.0.0.rc1...v3.0.0)

**Closed issues:**

- id not generated before before\_create callback called [\#322](https://github.com/thoughtbot/factory_girl/issues/322)

- Attribute aliasing breaks assignment [\#321](https://github.com/thoughtbot/factory_girl/issues/321)

- Is :note a reserved symbol? [\#317](https://github.com/thoughtbot/factory_girl/issues/317)

## [v3.0.0.rc1](https://github.com/thoughtbot/factory_girl/tree/v3.0.0.rc1) (2012-03-16)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.6.4...v3.0.0.rc1)

**Closed issues:**

- Infinite loops... [\#319](https://github.com/thoughtbot/factory_girl/issues/319)

## [v2.6.4](https://github.com/thoughtbot/factory_girl/tree/v2.6.4) (2012-03-16)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.6.3...v2.6.4)

**Closed issues:**

- Create an association with attributes from the parent [\#318](https://github.com/thoughtbot/factory_girl/issues/318)

- Associations in attributes\_for [\#316](https://github.com/thoughtbot/factory_girl/issues/316)

- Nested attributes double records [\#314](https://github.com/thoughtbot/factory_girl/issues/314)

- - [\#312](https://github.com/thoughtbot/factory_girl/issues/312)

**Merged pull requests:**

- Factory Girl 3.0 [\#320](https://github.com/thoughtbot/factory_girl/pull/320) ([joshuaclayton](https://github.com/joshuaclayton))

- Do not ignore alias names of transient attributes. \(Fixes \#311\) [\#315](https://github.com/thoughtbot/factory_girl/pull/315) ([ijcd](https://github.com/ijcd))

- Made the : optional, to avoid issues. [\#310](https://github.com/thoughtbot/factory_girl/pull/310) ([cj](https://github.com/cj))

## [v2.6.3](https://github.com/thoughtbot/factory_girl/tree/v2.6.3) (2012-03-09)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.6.2...v2.6.3)

**Closed issues:**

- Magic alias ignoring is blocking set of attribute :foo\_id if :foo is an override [\#311](https://github.com/thoughtbot/factory_girl/issues/311)

**Merged pull requests:**

- fix FactoryRunner\#run bug re: uncompiled factory [\#305](https://github.com/thoughtbot/factory_girl/pull/305) ([barunio](https://github.com/barunio))

## [v2.6.2](https://github.com/thoughtbot/factory_girl/tree/v2.6.2) (2012-03-09)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.6.1...v2.6.2)

**Closed issues:**

- Constructing one-off factories? [\#307](https://github.com/thoughtbot/factory_girl/issues/307)

- DuplicateDefinitionError when defining a :post factory [\#306](https://github.com/thoughtbot/factory_girl/issues/306)

- Passing id of first association to second association [\#302](https://github.com/thoughtbot/factory_girl/issues/302)

- Name collision with active record model named Factory [\#301](https://github.com/thoughtbot/factory_girl/issues/301)

- Dependent attributes broken in 1.3.3 [\#297](https://github.com/thoughtbot/factory_girl/issues/297)

**Merged pull requests:**

- Made the : optional. [\#309](https://github.com/thoughtbot/factory_girl/pull/309) ([cj](https://github.com/cj))

- \[FIX\] Not sure why the : was there, it broke the step. [\#308](https://github.com/thoughtbot/factory_girl/pull/308) ([cj](https://github.com/cj))

- allow passing traits to vintage Factory syntax [\#304](https://github.com/thoughtbot/factory_girl/pull/304) ([barunio](https://github.com/barunio))

- Allow factories to use all ancestors' traits [\#303](https://github.com/thoughtbot/factory_girl/pull/303) ([barunio](https://github.com/barunio))

- Add Proxy\#association\_list for adding lists of assocations in definitions [\#295](https://github.com/thoughtbot/factory_girl/pull/295) ([sj26](https://github.com/sj26))

## [v2.6.1](https://github.com/thoughtbot/factory_girl/tree/v2.6.1) (2012-03-02)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.6.0...v2.6.1)

**Closed issues:**

- timestamps attributes gets the wrong date [\#300](https://github.com/thoughtbot/factory_girl/issues/300)

**Merged pull requests:**

- Remove AssociationRunner in lieu of FactoryRunner [\#299](https://github.com/thoughtbot/factory_girl/pull/299) ([joshuaclayton](https://github.com/joshuaclayton))

- Move callback\_names onto FactoryGirl module [\#298](https://github.com/thoughtbot/factory_girl/pull/298) ([joshuaclayton](https://github.com/joshuaclayton))

## [v2.6.0](https://github.com/thoughtbot/factory_girl/tree/v2.6.0) (2012-02-17)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.5.2...v2.6.0)

**Closed issues:**

- create\_list with Traits [\#294](https://github.com/thoughtbot/factory_girl/issues/294)

- Undefined method error raised when creating instance [\#290](https://github.com/thoughtbot/factory_girl/issues/290)

- Machinist syntax features [\#284](https://github.com/thoughtbot/factory_girl/issues/284)

- FactoryGirl::AttributeDefinitionError - strange error message [\#275](https://github.com/thoughtbot/factory_girl/issues/275)

- Using traits for an association [\#263](https://github.com/thoughtbot/factory_girl/issues/263)

- More documentation needed for complex \(real-world\) model schema [\#230](https://github.com/thoughtbot/factory_girl/issues/230)

- Documentation for creating has\_many associations [\#202](https://github.com/thoughtbot/factory_girl/issues/202)

**Merged pull requests:**

- Rename FactoryGirl::Proxy to FactoryGirl::Strategy [\#296](https://github.com/thoughtbot/factory_girl/pull/296) ([joshuaclayton](https://github.com/joshuaclayton))

## [v2.5.2](https://github.com/thoughtbot/factory_girl/tree/v2.5.2) (2012-02-10)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.5.1...v2.5.2)

**Closed issues:**

- can't use inherited associations in Cucumber steps [\#292](https://github.com/thoughtbot/factory_girl/issues/292)

- Factory definitions with WikiWord class names not allowed [\#286](https://github.com/thoughtbot/factory_girl/issues/286)

- :y cannot be overwritten unless specified in factory [\#285](https://github.com/thoughtbot/factory_girl/issues/285)

- has\_many through with added columns in join table [\#283](https://github.com/thoughtbot/factory_girl/issues/283)

- nested attributes doubling up [\#282](https://github.com/thoughtbot/factory_girl/issues/282)

**Merged pull requests:**

- Let Cucumber steps use inherited associations. [\#293](https://github.com/thoughtbot/factory_girl/pull/293) ([eostrom](https://github.com/eostrom))

- Add runtime traits support to build\_list and create\_list [\#291](https://github.com/thoughtbot/factory_girl/pull/291) ([weppos](https://github.com/weppos))

## [v2.5.1](https://github.com/thoughtbot/factory_girl/tree/v2.5.1) (2012-02-03)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.5.0...v2.5.1)

**Closed issues:**

- The create\_list method doesn't work quiet well [\#289](https://github.com/thoughtbot/factory_girl/issues/289)

- traits "fall off" of the inheritance chain after first degree of inheritance [\#281](https://github.com/thoughtbot/factory_girl/issues/281)

- :parent seems to be ignored for nested factory definitions [\#280](https://github.com/thoughtbot/factory_girl/issues/280)

- "ArgumentError: too few arguments" using :format attribute [\#279](https://github.com/thoughtbot/factory_girl/issues/279)

**Merged pull requests:**

- Update rubygems on travis-ci.org before running dependency installation [\#288](https://github.com/thoughtbot/factory_girl/pull/288) ([michaelklishin](https://github.com/michaelklishin))

- Change getting started doc to remove old "FactoryGirl.stub" method [\#287](https://github.com/thoughtbot/factory_girl/pull/287) ([carlosantoniodasilva](https://github.com/carlosantoniodasilva))

## [v2.5.0](https://github.com/thoughtbot/factory_girl/tree/v2.5.0) (2012-01-21)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.4.2...v2.5.0)

**Closed issues:**

- NoMethodError: undefined method `attributes' [\#277](https://github.com/thoughtbot/factory_girl/issues/277)

- Trait not registered: class [\#276](https://github.com/thoughtbot/factory_girl/issues/276)

- Consider undeprecating attributes\_for [\#274](https://github.com/thoughtbot/factory_girl/issues/274)

- Traits aren't applied when building models [\#272](https://github.com/thoughtbot/factory_girl/issues/272)

- Setting the association doesn't set the id [\#271](https://github.com/thoughtbot/factory_girl/issues/271)

- Create or build factory for an association [\#252](https://github.com/thoughtbot/factory_girl/issues/252)

**Merged pull requests:**

- Initialize with [\#278](https://github.com/thoughtbot/factory_girl/pull/278) ([joshuaclayton](https://github.com/joshuaclayton))

- Fix inline traits [\#273](https://github.com/thoughtbot/factory_girl/pull/273) ([joshuaclayton](https://github.com/joshuaclayton))

## [v2.4.2](https://github.com/thoughtbot/factory_girl/tree/v2.4.2) (2012-01-18)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.4.1...v2.4.2)

## [v2.4.1](https://github.com/thoughtbot/factory_girl/tree/v2.4.1) (2012-01-17)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.4.0...v2.4.1)

**Closed issues:**

- Traits don't work when using with construction methods in Rails [\#270](https://github.com/thoughtbot/factory_girl/issues/270)

- factory\_girl does not reload model files [\#269](https://github.com/thoughtbot/factory_girl/issues/269)

- Attributes\_for returns factory instead of list of attributes under Rails 3.2 [\#261](https://github.com/thoughtbot/factory_girl/issues/261)

- Passing an argument to attribute block definition skips block evaluation [\#257](https://github.com/thoughtbot/factory_girl/issues/257)

**Merged pull requests:**

- Make traits work after Factory\(\) was called. [\#268](https://github.com/thoughtbot/factory_girl/pull/268) ([greyblake](https://github.com/greyblake))

## [v2.4.0](https://github.com/thoughtbot/factory_girl/tree/v2.4.0) (2012-01-13)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.3.2...v2.4.0)

**Closed issues:**

- Using Factory's Model Instance Within Blocks? [\#264](https://github.com/thoughtbot/factory_girl/issues/264)

- testing all factories at once [\#262](https://github.com/thoughtbot/factory_girl/issues/262)

- after\_destroy callback not called when record created by FactoryGirl [\#259](https://github.com/thoughtbot/factory_girl/issues/259)

- NoMethodError: undefined method `substitute' for \#<Account:0x00000100d00f88\> [\#251](https://github.com/thoughtbot/factory_girl/issues/251)

- Overidden attributes are not set in after\_initialize callbacks. [\#250](https://github.com/thoughtbot/factory_girl/issues/250)

- FactoryGirl sequencing not giving unique value [\#249](https://github.com/thoughtbot/factory_girl/issues/249)

- Overriding a foreign key not working. [\#248](https://github.com/thoughtbot/factory_girl/issues/248)

- Declaring associations in Factory Girl 2+ [\#239](https://github.com/thoughtbot/factory_girl/issues/239)

- Non expected created association [\#231](https://github.com/thoughtbot/factory_girl/issues/231)

**Merged pull requests:**

- Make the examples use Ruby syntax highlighting on GitHub. [\#267](https://github.com/thoughtbot/factory_girl/pull/267) ([dasch](https://github.com/dasch))

- Trivial gem and README updates [\#266](https://github.com/thoughtbot/factory_girl/pull/266) ([weppos](https://github.com/weppos))

- Class inheritance [\#265](https://github.com/thoughtbot/factory_girl/pull/265) ([joshuaclayton](https://github.com/joshuaclayton))

- Add dependency status to README [\#260](https://github.com/thoughtbot/factory_girl/pull/260) ([laserlemon](https://github.com/laserlemon))

- Ensure the proper result is returned when block is passed [\#258](https://github.com/thoughtbot/factory_girl/pull/258) ([weppos](https://github.com/weppos))

- Refactor proxy and evaluators [\#256](https://github.com/thoughtbot/factory_girl/pull/256) ([joshuaclayton](https://github.com/joshuaclayton))

- Be more agnostic to ORMs when using columns [\#255](https://github.com/thoughtbot/factory_girl/pull/255) ([dnagir](https://github.com/dnagir))

- Be more agnostic to ORMs when using columns [\#254](https://github.com/thoughtbot/factory_girl/pull/254) ([dnagir](https://github.com/dnagir))

- Supplying a Class to a factory that overrides to\_s no longer results in ... [\#253](https://github.com/thoughtbot/factory_girl/pull/253) ([elarkin](https://github.com/elarkin))

## [v2.3.2](https://github.com/thoughtbot/factory_girl/tree/v2.3.2) (2011-11-26)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.3.1...v2.3.2)

**Closed issues:**

- dynamic attributes in traits dont get evaluated in the expected order [\#247](https://github.com/thoughtbot/factory_girl/issues/247)

- Trait callbacks run out of order [\#246](https://github.com/thoughtbot/factory_girl/issues/246)

## [v2.3.1](https://github.com/thoughtbot/factory_girl/tree/v2.3.1) (2011-11-23)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.3.0...v2.3.1)

**Closed issues:**

- undefined method `next' for Factory:Module when using Ruby 1.9.3 [\#245](https://github.com/thoughtbot/factory_girl/issues/245)

- :build creates a record for associations of factory [\#243](https://github.com/thoughtbot/factory_girl/issues/243)

- Conflicts with existing model "Factory" [\#242](https://github.com/thoughtbot/factory_girl/issues/242)

**Merged pull requests:**

- AttributeList's @attributes is an array until it needs to sort attributes [\#244](https://github.com/thoughtbot/factory_girl/pull/244) ([joshuaclayton](https://github.com/joshuaclayton))

## [v2.3.0](https://github.com/thoughtbot/factory_girl/tree/v2.3.0) (2011-11-18)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.2.0...v2.3.0)

**Closed issues:**

- defining factory attributes with multi-line strings outputs new lines in console running specs [\#238](https://github.com/thoughtbot/factory_girl/issues/238)

- Using callbacks within decorate [\#237](https://github.com/thoughtbot/factory_girl/issues/237)

- Get the last sequence a second time [\#235](https://github.com/thoughtbot/factory_girl/issues/235)

- trouble with association [\#232](https://github.com/thoughtbot/factory_girl/issues/232)

- undefined method times for \#<FactoryGirl::Declaration::Static \(NoMethodError\) [\#229](https://github.com/thoughtbot/factory_girl/issues/229)

- Allow to pass additional options to `.build` or `.create` [\#227](https://github.com/thoughtbot/factory_girl/issues/227)

- Support `before` callback [\#226](https://github.com/thoughtbot/factory_girl/issues/226)

- Link to getting started on README is broken [\#223](https://github.com/thoughtbot/factory_girl/issues/223)

- Troubles with belongs\_to association [\#222](https://github.com/thoughtbot/factory_girl/issues/222)

- Support nested\_attributes [\#221](https://github.com/thoughtbot/factory_girl/issues/221)

- Using rand\(\) at factory definitions [\#219](https://github.com/thoughtbot/factory_girl/issues/219)

**Merged pull requests:**

- I've grown up to be a woman [\#241](https://github.com/thoughtbot/factory_girl/pull/241) ([hgmnz](https://github.com/hgmnz))

- Traits can be added to factories when the factory creates an instance [\#240](https://github.com/thoughtbot/factory_girl/pull/240) ([joshuaclayton](https://github.com/joshuaclayton))

- Make date consistent with later convention \(i.e. September 02, 2011\) [\#236](https://github.com/thoughtbot/factory_girl/pull/236) ([craiglittle](https://github.com/craiglittle))

- Use bundler conventions [\#234](https://github.com/thoughtbot/factory_girl/pull/234) ([gabebw](https://github.com/gabebw))

- Use correct module in docs. [\#233](https://github.com/thoughtbot/factory_girl/pull/233) ([gabebw](https://github.com/gabebw))

- fixed typo [\#228](https://github.com/thoughtbot/factory_girl/pull/228) ([ayrton](https://github.com/ayrton))

- Fixing typo in GETTING\_STARTED.md [\#225](https://github.com/thoughtbot/factory_girl/pull/225) ([agronemann](https://github.com/agronemann))

- Big letters in factory name [\#224](https://github.com/thoughtbot/factory_girl/pull/224) ([morgoth](https://github.com/morgoth))

- Hi! We cleaned up your code for you! [\#220](https://github.com/thoughtbot/factory_girl/pull/220) ([GunioRobot](https://github.com/GunioRobot))

- Working rcov Rake task. [\#218](https://github.com/thoughtbot/factory_girl/pull/218) ([gabebw](https://github.com/gabebw))

- Use correct parameters in specs for FactoryGirl::Attribute::Dynamic class [\#217](https://github.com/thoughtbot/factory_girl/pull/217) ([pacoguzman](https://github.com/pacoguzman))

## [v2.2.0](https://github.com/thoughtbot/factory_girl/tree/v2.2.0) (2011-10-14)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.1.2...v2.2.0)

**Fixed bugs:**

- Registry breaks Pickle FactoryGirl Adapter [\#129](https://github.com/thoughtbot/factory_girl/issues/129)

**Closed issues:**

- Having an inheritance \(?\) issue after upgrading from 1.3.3 to 2.1.2 [\#211](https://github.com/thoughtbot/factory_girl/issues/211)

- syntax methods with block [\#210](https://github.com/thoughtbot/factory_girl/issues/210)

- Weird behaviour when a block is passed in with an argument for not a sequence [\#209](https://github.com/thoughtbot/factory_girl/issues/209)

- 2.1.1 throws undefined method `inherit\_from'  [\#207](https://github.com/thoughtbot/factory_girl/issues/207)

- Allow attributes from traits on parent factories to be overridden on child factories \(either by traits or individual attributes\) [\#197](https://github.com/thoughtbot/factory_girl/issues/197)

**Merged pull requests:**

- Spec suite cleanup [\#216](https://github.com/thoughtbot/factory_girl/pull/216) ([justinko](https://github.com/justinko))

- Calling the syntax methods with a block yields the return object. [\#215](https://github.com/thoughtbot/factory_girl/pull/215) ([justinko](https://github.com/justinko))

- Updated ignored attributes documentation [\#214](https://github.com/thoughtbot/factory_girl/pull/214) ([ozzyaaron](https://github.com/ozzyaaron))

- use create\_list in step definitions [\#213](https://github.com/thoughtbot/factory_girl/pull/213) ([nashby](https://github.com/nashby))

- Improved error messages in Registry [\#212](https://github.com/thoughtbot/factory_girl/pull/212) ([davetron5000](https://github.com/davetron5000))

- Changelog \(2.1.0 -\> 2.1.1\) [\#208](https://github.com/thoughtbot/factory_girl/pull/208) ([janxious](https://github.com/janxious))

## [v2.1.2](https://github.com/thoughtbot/factory_girl/tree/v2.1.2) (2011-09-23)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.1.1...v2.1.2)

**Merged pull requests:**

- Use activesupport [\#206](https://github.com/thoughtbot/factory_girl/pull/206) ([joshuaclayton](https://github.com/joshuaclayton))

## [v2.1.1](https://github.com/thoughtbot/factory_girl/tree/v2.1.1) (2011-09-23)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.1.0...v2.1.1)

**Closed issues:**

- \[FactoryGirl + rspec2 + rails 3.1.0\] In rspec if i use FactoryGirl, the model don't execute the last sql statement [\#204](https://github.com/thoughtbot/factory_girl/issues/204)

- Using name-spaced models [\#199](https://github.com/thoughtbot/factory_girl/issues/199)

- Undefined Method error with Rails 3.1.0, Factory\_girl 2.1.0 [\#198](https://github.com/thoughtbot/factory_girl/issues/198)

**Merged pull requests:**

- Declarations [\#205](https://github.com/thoughtbot/factory_girl/pull/205) ([joshuaclayton](https://github.com/joshuaclayton))

- Make sure parent callbacks are run before child [\#203](https://github.com/thoughtbot/factory_girl/pull/203) ([twalpole](https://github.com/twalpole))

- More specific instructions for cucumber integration [\#201](https://github.com/thoughtbot/factory_girl/pull/201) ([ovargas27](https://github.com/ovargas27))

- A start on changelog for the current version [\#200](https://github.com/thoughtbot/factory_girl/pull/200) ([janxious](https://github.com/janxious))

## [v2.1.0](https://github.com/thoughtbot/factory_girl/tree/v2.1.0) (2011-09-02)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.5...v2.1.0)

**Fixed bugs:**

- Factory.create caches serialized fields [\#121](https://github.com/thoughtbot/factory_girl/issues/121)

**Closed issues:**

- reload in console? [\#196](https://github.com/thoughtbot/factory_girl/issues/196)

- API to get the class of a proxied object? [\#195](https://github.com/thoughtbot/factory_girl/issues/195)

- Argument Error: Not registered using factory\_girl 1.1.0 with rails 3.1.0.rc8 [\#194](https://github.com/thoughtbot/factory_girl/issues/194)

- Attribute encoding of sequences in ruby 1.9.3-preview1 [\#192](https://github.com/thoughtbot/factory_girl/issues/192)

- Errors should include the factory and field being defined [\#189](https://github.com/thoughtbot/factory_girl/issues/189)

- Monkey patching factories [\#127](https://github.com/thoughtbot/factory_girl/issues/127)

**Merged pull requests:**

- Load factories from /factories at the Rails root, just like the default definition\_file\_paths. [\#193](https://github.com/thoughtbot/factory_girl/pull/193) ([cgriego](https://github.com/cgriego))

- typo fix [\#190](https://github.com/thoughtbot/factory_girl/pull/190) ([betelgeuse](https://github.com/betelgeuse))

## [v2.0.5](https://github.com/thoughtbot/factory_girl/tree/v2.0.5) (2011-08-24)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.4...v2.0.5)

**Closed issues:**

- attribute.ignore throws "undefined method `ignore' for \#<Arrayxxxxx\>" [\#188](https://github.com/thoughtbot/factory_girl/issues/188)

- cucumber step definition and column transforms [\#185](https://github.com/thoughtbot/factory_girl/issues/185)

- Change AttributeList to maintain a hash of priorities and an array of values [\#184](https://github.com/thoughtbot/factory_girl/issues/184)

- Slow Factories [\#183](https://github.com/thoughtbot/factory_girl/issues/183)

- 'Not registered' error for registered factory class [\#180](https://github.com/thoughtbot/factory_girl/issues/180)

**Merged pull requests:**

- Allow static/dynamic attributes to be overridden with dynamic/static attributes [\#186](https://github.com/thoughtbot/factory_girl/pull/186) ([twalpole](https://github.com/twalpole))

- Fixes documentation for association on create. [\#182](https://github.com/thoughtbot/factory_girl/pull/182) ([JDutil](https://github.com/JDutil))

- Replace Factory.next with FactoryGirl.generate in Getting Started guide [\#181](https://github.com/thoughtbot/factory_girl/pull/181) ([tomstuart](https://github.com/tomstuart))

- Use \#first in step definitions [\#179](https://github.com/thoughtbot/factory_girl/pull/179) ([bkeepers](https://github.com/bkeepers))

- Prevents RSpec from throwing a deprecation warning when mixing in syntax [\#178](https://github.com/thoughtbot/factory_girl/pull/178) ([Jonplussed](https://github.com/Jonplussed))

- Ensure static attributes are consistently prioritized [\#177](https://github.com/thoughtbot/factory_girl/pull/177) ([twalpole](https://github.com/twalpole))

## [v2.0.4](https://github.com/thoughtbot/factory_girl/tree/v2.0.4) (2011-08-12)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.3...v2.0.4)

**Fixed bugs:**

- Overrides don't respect attribute definition order [\#140](https://github.com/thoughtbot/factory_girl/issues/140)

**Closed issues:**

- Bi-directional Associations are not set up [\#172](https://github.com/thoughtbot/factory_girl/issues/172)

- Specs packaged as part of gem cause 'Factory already defined' error [\#170](https://github.com/thoughtbot/factory_girl/issues/170)

**Merged pull requests:**

- Now able to specify :method =\> :build in a factory's association. [\#191](https://github.com/thoughtbot/factory_girl/pull/191) ([jkingdon](https://github.com/jkingdon))

- Fix the travis-ci build status image. [\#176](https://github.com/thoughtbot/factory_girl/pull/176) ([JDutil](https://github.com/JDutil))

- Attribute groups support as discussed in issue \#132 [\#175](https://github.com/thoughtbot/factory_girl/pull/175) ([twalpole](https://github.com/twalpole))

- replace sort! with partition and flatten [\#174](https://github.com/thoughtbot/factory_girl/pull/174) ([twalpole](https://github.com/twalpole))

- non-overriden parent dynamic methods should be assigned before dynamic child attributes [\#173](https://github.com/thoughtbot/factory_girl/pull/173) ([twalpole](https://github.com/twalpole))

- Factory overrides are applied before other attributes. Fixes \#140. [\#171](https://github.com/thoughtbot/factory_girl/pull/171) ([metaskills](https://github.com/metaskills))

- Factory overrides are applied before other attributes. Fixes \#140. [\#169](https://github.com/thoughtbot/factory_girl/pull/169) ([metaskills](https://github.com/metaskills))

## [v2.0.3](https://github.com/thoughtbot/factory_girl/tree/v2.0.3) (2011-08-05)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.2...v2.0.3)

**Fixed bugs:**

- \#find\_definitions not reloading [\#161](https://github.com/thoughtbot/factory_girl/issues/161)

- 1.1.rc1 - can't convert true into String [\#154](https://github.com/thoughtbot/factory_girl/issues/154)

- Attribute name 'link' throws error [\#152](https://github.com/thoughtbot/factory_girl/issues/152)

- Release 1.3.3 breaks BC with option :parent [\#119](https://github.com/thoughtbot/factory_girl/issues/119)

**Closed issues:**

- Error with Rails 3.1 rc4, Ruby 1.9: ArgumentError: Not registered [\#168](https://github.com/thoughtbot/factory_girl/issues/168)

- Strange DSL behavior in ruby-1.9.3-preview1 [\#167](https://github.com/thoughtbot/factory_girl/issues/167)

- really strange behavior of factory girl under ruby-1.9.3-preview1 [\#166](https://github.com/thoughtbot/factory_girl/issues/166)

- the old syntax not working with ruby 1.9.3 preview1 [\#165](https://github.com/thoughtbot/factory_girl/issues/165)

- Trying to access an "id" attribute on an attribute proxies calls Object\#object\_id [\#163](https://github.com/thoughtbot/factory_girl/issues/163)

- no such file to load -- test/factories.rb [\#153](https://github.com/thoughtbot/factory_girl/issues/153)

- Undefined method 'each' on has\_many associations \(FactoryGirl2\) [\#96](https://github.com/thoughtbot/factory_girl/issues/96)

**Merged pull requests:**

- Simpler association syntax [\#100](https://github.com/thoughtbot/factory_girl/pull/100) ([szimek](https://github.com/szimek))

## [v2.0.2](https://github.com/thoughtbot/factory_girl/tree/v2.0.2) (2011-07-28)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.1...v2.0.2)

**Closed issues:**

- Unable to create\_list [\#160](https://github.com/thoughtbot/factory_girl/issues/160)

**Merged pull requests:**

- Update Gemfile versions in getting started documentation [\#162](https://github.com/thoughtbot/factory_girl/pull/162) ([huerlisi](https://github.com/huerlisi))

## [v2.0.1](https://github.com/thoughtbot/factory_girl/tree/v2.0.1) (2011-07-22)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0...v2.0.1)

## [v2.0.0](https://github.com/thoughtbot/factory_girl/tree/v2.0.0) (2011-07-22)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0.rc4...v2.0.0)

**Fixed bugs:**

- 289ba4316 broke instantiating factories in Rails 3 [\#156](https://github.com/thoughtbot/factory_girl/issues/156)

- associations are not being evaluated when called from a block [\#136](https://github.com/thoughtbot/factory_girl/issues/136)

**Merged pull requests:**

- Ensure static attributes are executed before dynamic ones. [\#159](https://github.com/thoughtbot/factory_girl/pull/159) ([flavio](https://github.com/flavio))

- Added spec parent factories that verifies a child can use an attribute se [\#158](https://github.com/thoughtbot/factory_girl/pull/158) ([aepstein](https://github.com/aepstein))

## [v2.0.0.rc4](https://github.com/thoughtbot/factory_girl/tree/v2.0.0.rc4) (2011-07-08)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0.rc3...v2.0.0.rc4)

**Merged pull requests:**

- convert method name to string when determining when to undef unproxied methods [\#157](https://github.com/thoughtbot/factory_girl/pull/157) ([matthuhiggins](https://github.com/matthuhiggins))

## [v2.0.0.rc3](https://github.com/thoughtbot/factory_girl/tree/v2.0.0.rc3) (2011-07-05)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0.rc2...v2.0.0.rc3)

## [v2.0.0.rc2](https://github.com/thoughtbot/factory_girl/tree/v2.0.0.rc2) (2011-07-05)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0.rc1...v2.0.0.rc2)

**Merged pull requests:**

- More clear install message [\#155](https://github.com/thoughtbot/factory_girl/pull/155) ([gmile](https://github.com/gmile))

## [v2.0.0.rc1](https://github.com/thoughtbot/factory_girl/tree/v2.0.0.rc1) (2011-07-01)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0.beta5...v2.0.0.rc1)

## [v2.0.0.beta5](https://github.com/thoughtbot/factory_girl/tree/v2.0.0.beta5) (2011-06-30)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0.beta4...v2.0.0.beta5)

## [v2.0.0.beta4](https://github.com/thoughtbot/factory_girl/tree/v2.0.0.beta4) (2011-06-29)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v2.0.0.beta3...v2.0.0.beta4)

## [v2.0.0.beta3](https://github.com/thoughtbot/factory_girl/tree/v2.0.0.beta3) (2011-06-29)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.3.3...v2.0.0.beta3)

**Fixed bugs:**

- Breaks routing with Factory.stub under Rails 3.0.2 [\#145](https://github.com/thoughtbot/factory_girl/issues/145)

- Tests were failing in ruby 1.9.2 [\#97](https://github.com/thoughtbot/factory_girl/issues/97)

**Closed issues:**

- Dependent attributes should be able to depend on attributes overridden in child factories [\#151](https://github.com/thoughtbot/factory_girl/issues/151)

- Add factory definitions recursively [\#150](https://github.com/thoughtbot/factory_girl/issues/150)

- ActiveSupport::SecureRandom deprecated in rails 3.1 [\#149](https://github.com/thoughtbot/factory_girl/issues/149)

- Support for singleton models [\#148](https://github.com/thoughtbot/factory_girl/issues/148)

- uninitialized constant FactoryGirl [\#147](https://github.com/thoughtbot/factory_girl/issues/147)

- Factory.create affects method overriding in User class [\#146](https://github.com/thoughtbot/factory_girl/issues/146)

- ActiveRecord Callbacks don't fire when update\_attributes called from a FactoryGirl created Factory [\#143](https://github.com/thoughtbot/factory_girl/issues/143)

- Associated models should respect factored object [\#139](https://github.com/thoughtbot/factory_girl/issues/139)

- Observer not getting called when I use factory [\#138](https://github.com/thoughtbot/factory_girl/issues/138)

- Unknown strategy: instance [\#137](https://github.com/thoughtbot/factory_girl/issues/137)

- \[Feature Request\] Ability to fix sequence numbers for tests [\#135](https://github.com/thoughtbot/factory_girl/issues/135)

- Add new machinst syntax [\#133](https://github.com/thoughtbot/factory_girl/issues/133)

- belongs\_to association with specific value not saved [\#131](https://github.com/thoughtbot/factory_girl/issues/131)

- Array sequences [\#128](https://github.com/thoughtbot/factory_girl/issues/128)

- Factory vs FactoryGirl [\#124](https://github.com/thoughtbot/factory_girl/issues/124)

- Better error message for step definition [\#107](https://github.com/thoughtbot/factory_girl/issues/107)

- Error in Readme? [\#106](https://github.com/thoughtbot/factory_girl/issues/106)

- Sequences should default to one-up integers [\#101](https://github.com/thoughtbot/factory_girl/issues/101)

- Changing make to build and adding make! for create [\#83](https://github.com/thoughtbot/factory_girl/issues/83)

- Having an attribute named timeout breaks factory\_girl under jruby [\#69](https://github.com/thoughtbot/factory_girl/issues/69)

- Allow variables to be passed to factory while, create/build/attributes\_for calls are made [\#67](https://github.com/thoughtbot/factory_girl/issues/67)

- Add a locate existing functionality [\#61](https://github.com/thoughtbot/factory_girl/issues/61)

**Merged pull requests:**

- Adds transient variables to allow arbitrary factory parameters [\#142](https://github.com/thoughtbot/factory_girl/pull/142) ([kibiz0r](https://github.com/kibiz0r))

- Adds transient variables to allow arbitrary factory parameters [\#141](https://github.com/thoughtbot/factory_girl/pull/141) ([kibiz0r](https://github.com/kibiz0r))

- Adds new machinst make & make! syntax [\#134](https://github.com/thoughtbot/factory_girl/pull/134) ([RobertLowe](https://github.com/RobertLowe))

- There was a possible error in the GETTING STARTED doc [\#130](https://github.com/thoughtbot/factory_girl/pull/130) ([volkanunsal](https://github.com/volkanunsal))

- Fix association id when stubbing [\#114](https://github.com/thoughtbot/factory_girl/pull/114) ([pietern](https://github.com/pietern))

- Did this ever get merged in? [\#105](https://github.com/thoughtbot/factory_girl/pull/105) ([robotarmy](https://github.com/robotarmy))

## [v1.3.3](https://github.com/thoughtbot/factory_girl/tree/v1.3.3) (2011-01-11)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.3.2...v1.3.3)

## [v1.3.2](https://github.com/thoughtbot/factory_girl/tree/v1.3.2) (2010-08-03)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.3.1...v1.3.2)

**Closed issues:**

- Fix loading factories from Rails root in Rails 2.x  [\#65](https://github.com/thoughtbot/factory_girl/issues/65)

## [v1.3.1](https://github.com/thoughtbot/factory_girl/tree/v1.3.1) (2010-06-23)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.3.0...v1.3.1)

## [v1.3.0](https://github.com/thoughtbot/factory_girl/tree/v1.3.0) (2010-06-10)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.0.0...v1.3.0)

## [v1.0.0](https://github.com/thoughtbot/factory_girl/tree/v1.0.0) (2010-06-09)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.2.5...v1.0.0)

## [v1.2.5](https://github.com/thoughtbot/factory_girl/tree/v1.2.5) (2010-05-20)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.2.4...v1.2.5)

## [v1.2.4](https://github.com/thoughtbot/factory_girl/tree/v1.2.4) (2010-03-30)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/v1.2.3...v1.2.4)

## [v1.2.3](https://github.com/thoughtbot/factory_girl/tree/v1.2.3) (2009-10-16)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-2-2...v1.2.3)

## [rel_1-2-2](https://github.com/thoughtbot/factory_girl/tree/rel_1-2-2) (2009-07-15)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-2-1...rel_1-2-2)

## [rel_1-2-1](https://github.com/thoughtbot/factory_girl/tree/rel_1-2-1) (2009-04-09)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-2-0...rel_1-2-1)

## [rel_1-2-0](https://github.com/thoughtbot/factory_girl/tree/rel_1-2-0) (2009-02-17)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-1-5...rel_1-2-0)

## [rel_1-1-5](https://github.com/thoughtbot/factory_girl/tree/rel_1-1-5) (2008-12-11)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-1-4...rel_1-1-5)

## [rel_1-1-4](https://github.com/thoughtbot/factory_girl/tree/rel_1-1-4) (2008-11-28)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-1-3...rel_1-1-4)

## [rel_1-1-3](https://github.com/thoughtbot/factory_girl/tree/rel_1-1-3) (2008-09-12)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-1-2...rel_1-1-3)

## [rel_1-1-2](https://github.com/thoughtbot/factory_girl/tree/rel_1-1-2) (2008-07-30)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-1-1...rel_1-1-2)

## [rel_1-1-1](https://github.com/thoughtbot/factory_girl/tree/rel_1-1-1) (2008-06-23)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-1...rel_1-1-1)

## [rel_1-1](https://github.com/thoughtbot/factory_girl/tree/rel_1-1) (2008-06-03)

[Full Changelog](https://github.com/thoughtbot/factory_girl/compare/rel_1-0...rel_1-1)

## [rel_1-0](https://github.com/thoughtbot/factory_girl/tree/rel_1-0) (2008-05-31)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*