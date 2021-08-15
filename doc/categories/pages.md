

## Page Design

This section describes the elements of the design of the code in all pages 

### Principles

The functionality adheres to the following principles

- pages are self contained -  they do not interact with the server in amy way
- a page accepts input data in a [StepInput] object and creates output data in a [StepOutput] object.
  - the [StepInput] normally contains all the data that the pages needs to build itself
  - the [StepOutput] contains the entirety of the data that the page provides to any external object   
- a page interacts with the overall user journey via the [EventHandler] object provided in the constructor. It does so by passing in an event and a [StepOutput] object
- most pages interact via a [UserJourneyController] which implements the [EventHandler] Interface
- a page has no knowledge of which journey it belongs to or where it is in that journey
- all server interactions are mediated by the [UserJourneyController]. 
- the [UserJourneyController] maintains the state for the entire journey. This state is updated from the [StepOutput] object provided by the Page.