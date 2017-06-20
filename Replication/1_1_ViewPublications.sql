SELECT  --DISTINCT
        publications.*
FROM    sys.servers AS [publishers]
        INNER JOIN dbo.MSpublications AS [publications] ON publishers.server_id = publications.publisher_id
        INNER JOIN dbo.MSarticles AS [articles] ON publications.publication_id = articles.publication_id
        INNER JOIN dbo.MSsubscriptions AS [subscriptions] ON articles.article_id = subscriptions.article_id
                                                             AND articles.publication_id = subscriptions.publication_id
                                                             AND articles.publisher_db = subscriptions.publisher_db
                                                             AND articles.publisher_id = subscriptions.publisher_id
        INNER JOIN sys.servers AS [subscribers] ON subscriptions.subscriber_id = subscribers.server_id
--WHERE   publishers.name = 'MyPublisher'
--       AND publications.publication = 'MyPublication'
--       AND subscribers.name = 'MySubscriber';