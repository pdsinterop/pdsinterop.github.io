# Solid Interop in Practice

In July 2024, we reached out to a handful of developers who have produced end-user Solid apps to understand:

- interoperability challenges and ideals,
- how to make it easier for people to get into solid, and
- what improvements can be made to the developer experience.

[Noel De Martin](https://noeldemartin.com), [Vincent  Tunru](https://vincenttunru.com), [Timea Turdean](https://timeaturdean.com), and [Tim Standen](https://www.linkedin.com/in/tim-standen-6bb4b393) answered the call and their responses follow (edited for clarity, brevity, and flow).

---

# 1) What's your experience with making Solid apps interoperable? What challenges have you encountered? What possible solutions are you looking for or working on?

## Timea

Making Solid apps interoperable is possible, but you currently need to know how, which I believe is not easy. First, you need to know RDF and about data models/shapes/vocabularies. Then, you need to know about a Solid library in the language you use, or at least an RDF library. After you learn all these, you need to know where to find existing vocabularies if there are any. Then, if you want true interoperability, you need to share yours and properly document it, if you can find the right place…

So, while I have no problem with creating the data model myself, I didn't make time to share my vocabularies or shapes because I felt the ecosystem wasn't ready for it anyway.

I'm inclined to believe we need education in different specs of Solid in order for developers and data engineers to even want to share data models in the first place.

## Tim

I have created prototype versions of two apps so far: [PASS](https://github.com/codeforpdx/PASS), a management app for government housing data; and [Solid Calendar](https://github.com/timbot1789/solid-calendar), a personal calendar management app. The main challenges I have encountered are:

1. a lack of standardized discovery process by which an app can find a pod or determine what data is inside. Type Indexes attempt to solve this, but as a type index is not enforced by the server, it requires each app to enforce the type index. This makes the type index untrustworthy, as an app needs to be able to trust that all other apps using the type index are updating it properly. I am also aware of the existence of SAI, but it's unclear to me how to use it, or if it is supported in all servers. There's no guaranteed way to find a user's pod just knowing the user. Each Solid server implements its own system, and Inrupt's getUserPod function mostly just iterates through all the most common mechanisms.
2. Solid only permits one view or lens into the data, the view of containers and documents. This harms interoperability, because different apps may want to access the same data, but view it in a different way. In my housing data app, a government HUD worker may want to see only the data that is relevant to them (viewing more data, even accidentally, may be illegal). However, since retrieval can only be done on the document level, the worker can receive no guarantees that the document contains **all** the information they're seeking and **only** the information they're seeking. A similar issue exists with the Solid Calendar app. A user may want to view events over different time frames (days / weeks / months), or view events of a specific type (holidays / work events), but they can only fetch data according to the one lens enforced by the document structure (in my case, months).

For solutions to this problem, I've experimented with data retrieval via SparQL queries to the Solid server provider. This allows for the creation of more complex data views, and it makes data retrieval far more performant. However, this means my apps are not technically Solid compliant, and I'm not sure how this behaves with access control.

## Noel

I've made all my apps with interoperability in mind, but in practice I haven't seen others that are interoperable out of the box (maybe [Solidflix](https://github.com/OxfordHCC/solid-media/issues/8) was the closest one). Although I haven't seen many apps tackling the same use case as mine either.

One challenge is that the main story for interoperability is not clear, and there's no "official way" to do it. So each developer has to decide what they want to do. There are basically two possibilities now: Type Indexes and Solid Application Interoperability (SAI). Type Indexes is the only one you can use in practice, so it's the way my apps work, but it's still a draft and has some limitations, so I understand why some people don't use it yet. SAI is also still a draft and requires server-side implementation, so even though I'm very excited about it, I don't think I'll use it until it's part of the official spec and supported in most pods.

I'm interested in Shapes, but haven't used them yet because I haven't found any practical advantage for my apps. I'm also very interested in RDF reasoning and schema migrations, something like [Cambria](https://www.inkandswitch.com/cambria/) applied to Solid. As far as I know, all the current solutions for interop rely on knowing about some shapes during the implementation: to support new schemas, developers need to update their existing apps; this includes the work going on in solid-data-modules. I think it would be great if we could make apps interoperable after the fact, without requiring an update.

## Vincent

> What's your experience with making Solid apps interoperable?

I've tried to keep Penny working with ESS, CSS, and NSS, as far as basic functionality goes. It has some WAC-specific features, which only work on servers that support WAC. My other apps (which I'm not actively maintaining) primarily work with NSS.

> What challenges have you encountered?

It's already quite a challenge to keep Penny working with the different server implementations, because they differ so wildly in what specs they implement (WAC vs ACP, client IDs required or not, etc…), and also don't always agree on how to handle non-specced behaviour (e.g. does the user's profile point to a storage location?).

The reason that it's even doable with Penny is because it's only a very thin layer on top of the raw data, since it's an app for developers to inspect that data. For now, I've given up on building user-facing Solid apps because, even if I manage to get it to work with the different server solutions now (which is already a major hassle), both CSS and ESS have shown in the past that they're willing to change patterns that apps have come to rely on.

> What possible solutions are you looking for or working on?

Honestly, as I said, I've mostly given up for now, apart from Penny. I've decided to wait and re-evaluate until the following conditions hold:

1. Inrupt is supporting a paying customer with an app that works with any Solid server, not just ESS, and especially not a single instance of ESS.
2. Inrupt is supporting a paying customer hosting a pod that any app can connect to, not just allowlisted apps.

When that happens, I'll have some confidence that the ecosystem will have seen the worst of its churn.

I might make an exception for apps that only concern private data that applies to a single person (i.e. where I don't have to work with custom access controls), as the basics of just storing data is relatively stable. But I'll really have to feel like wanting to use such an app :)

---

# 2) Which aspects of app development more broadly do you struggle with? What kinds of tooling could be helpful with that?

## Vincent

It's mostly still just a hassle to lay out all the data the right way in a pod.

If we want proper interoperability _and_ stable apps, we're going to have to deal with literally every part of your data potentially not being there or being structured differently from what your app expects, which can results in literal exponential complexity.

And if an app were to be supported for a long time, without a doubt the data model will need regular updates, which means that the data in the user's pod needs to be migrated. But that data could have been written at any time, so migrations will need to be maintained indefinitely.

I'm still toying with the idea of one day writing a validator that allows you to define the data model, and then allows you to retrieve data that matches the model, and ensure that the data you write matches it too.

As I tend to focus on web apps, I suppose there's an adoption challenge in getting people to think about them as such, rather than automatically reaching for a phone's app store.

## Noel

I think I'm missing best practices and final specifications (as opposed to drafts) moreso than tooling. But that might be because I've been building my own tooling, so I'm biased there 😅. I'm missing some alternatives for authentication though, because at the moment Inrupt's library is the only existing solution.

If you want to know what I struggle with in App Development the list is endless xD. But to make it short, I'll only mention dependency hell :/. That is, making sure that updating one dependency doesn't break something, finding the compatible versions of two libraries, all the ESM vs CommonJS dilemma, etc. Dependency management in general is a bit of a mess, specially in JavaScript -.-. I think the problem arises from the fragmentation in the JS ecosystem, there are just too many tools and environments: Node, Deno, Bun, Webpack, Vite, Rollup, ESBuild, etc… All of that coupled with the fact that JavaScript is supposed to be backwards compatible, and add TypeScript into the mix, and you've got a big mess 😵. But it seems like most JS devs feel the same way, so I'm definitely not alone :/.

## Tim

A lot of Solid apps have moved to a design pattern of "load all the data you can from the pod into local memory, make changes locally, then commit all the changes back to the pod." This design pattern has numerous tradeoffs, but if it's the intended design pattern for pods, a framework that handles the data loading and saving for us would make things significantly easier.

## Timea

For me it's the frontend. I am not a designer to make things looks nice and functional at the same time 😅. And if one wants the RDF capability to make the frontend flexible, to adjust to the data model, well.. that is again difficult even if you know about RDF forms.

I know some of my friends are working on 'web components' for exactly this reason.

---

# 3) What comes to mind when you think about interoperability working well? Can you share any examples or inspirations?

## Tim

To me, interoperability means different apps can access the same data in new, novel ways that fit their use case. A todo app allows you to create calendar events for each todo item without opening your calendar. Emails can be opened with either a traditional "inbox" interface or an IM chat interface. You can message your doctor, and then in the chat, share your medical records with them.

## Vincent

I always was a bit sceptical about TimBL's "[Bag of Chips](https://www.w3.org/DesignIssues//BagOfChips.html)" idea: that different applications can look at different subsets of the same data. However, I recently tagged a Mastodon account on a Lemmy post, and then having their reply show up in-thread did feel magical. Likewise, when encountering an interesting post in my Mastodon timeline only to find out that it was a full-fledged blog, with replies shown as comments.

## Timea

Jackson Morgan's chat app LiquidChat and the one in SolidOS both use the same data.

What I would like to see is, for example, fitness data stored on my pod with different fitness apps writing it and displaying it; maybe one app tracks movement well and another is awesome at suggesting improvements based on that data.

## Noel

To me interoperability should be transparent, where users don't even notice that it's going on. Quite the opposite, an ecosystem with working interoperability would be one where users are surprised if an app is not compatible with others.

Some examples are Emails, RSS, the fediverse, webpages (browsers are interoperable), etc…

# 4) What potential / ideal / dream Solid interactions or app paradigms would get you excited as a developer? And as a user?

## Noel

As a developer, something like Cambria for Solid would be awesome. As I said, it would be great if it could work even without changing the code in my app. For example, if users themselves can "install schema translations" (or if that can happen automatically even better). In theory this is all possible with RDF reasoning, but in practice I don't think that's working anywhere.

As a user, I would like apps to leverage my pod data to augment the experience. For example, even though a recipe manager's main focus would be to manage recipes, it would be nice to see a list of friends when I'm sharing a recipe, or easily export the ingredients into a TODO list (visible in my Task Manager app), or schedule meals for specific days and see that in my Calendar app, etc… It would also be nice to see "companion apps". For example, I have an app to manage the movies I have watched or will watch. Some companion apps could be a movie recommendation engine, a social network where you see what your friends are watching, etc… There are infinite interesting things you can do with "movies", but if you try to fit everything in a single app it could become cluttered and bloated. With interoperable apps, many applications can work together to give users the experience they want without implementing every possible use case.

I've written more of my thoughts around this topic in [Interoperable Serendipity](https://noeldemartin.com/blog/interoperable-serendipity) and [Why Solid?](https://noeldemartin.com/blog/why-solid).

## Timea

Oh, I'm excited about everything when it comes to Solid so it's hard to choose ☺️ In theory, a developer can focus on creating the best frontend and functionality without bothering to learn databases and backend. Security topics which can be quite heavy should just work out of the box with Solid libraries and the developer shouldn't have to know how to configure it even (I'm thinking about spring security configuration which is not easy).

I see advantages for users who care about privacy or supporting local businesses (rather than data monopolies), and there will be more as the ecosystem develops. I want to see an explosion of maximizing the usage and benefit of one's data in every aspect (which is not possible at the moment).

## Vincent

I got interested in writing software because I was interested in what it could do for me, such as being able to learn from and keep in touch with people from all over the world, for example. Just the fact that Wikipedia exists is nothing short of amazing, to mention but one thing.

So what gets me excited as a developer is what gets me excited as a user. And the primary thing that gets me excited about Solid as a user is being able to have my data collected somewhere under my control, rather than the current status quo where it is scatted across various arbitrary servers, vulnerable to app developers cutting off my access to it any moment. For example, to have my photos somewhere where I can find them in fifteen years (rather than spread over the different platforms I've used over the past fifteen years, or worse, gone forever because those platforms are gone), and not used by e.g. Facebook to tell other people that I'm in their pictures, or whatever other uses they'll come up with in the future that I haven't thought about today.

## Tim

I imagine Solid as a highly interactive data vault that can store any data you want, and that you can carry around with you for your entire life. You don't need to worry about losing your computer, or changing operating systems, or updating software. It follows you forever, always understandable.

As a developer, I like the idea of being able to interact with any data I can get access to about a user. The ability to create links between any information that the user may have allows for a wide variety of creative applications.
