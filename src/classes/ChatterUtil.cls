/*
*   @description Various Chatter Utilities
*
*/
public with sharing class ChatterUtil {


    private static String[] supportedTags = new String[]{'b','strong','i','li','ol','p','s','u','ul', 'p'};

    /*
    * Replace unrecognized tags by Chatter
    */
    public static String replaceUnrecognizedTags(String body)
    {
        System.debug('before replace ' + body);
        Set<String> supportedTagsSet = new Set<String>();
        supportedTagsSet.addAll(supportedTags);

        //replace all br with p
        body = body.replaceAll('<br\\s*/?>', '<p></p>');

        //replace anchors with static text
        String link = '<a.*?\\s+href="(.*?)".*?>(.*?)</a>';

        Pattern MyPattern = Pattern.compile(link);
        Matcher MyMatcher = MyPattern.matcher(body);

        // input: html a tag output: anchor (link)
        while (MyMatcher.find()) {
            body = MyMatcher.replaceFirst(MyMatcher.group(2) + ' (' + MyMatcher.group(1) + ') ');
            MyMatcher.reset(body);
        }

        // remove all unsupported html tags
        String tag = '</?+([a-zAZ0-9]+).*?>';
        Pattern tagPattern = Pattern.compile(tag);
        Matcher tagMatcher = tagPattern.matcher(body);

        while (tagMatcher.find()) {
            System.debug('Found  ' + tagMatcher.group(1));
            if(!supportedTagsSet.contains(tagMatcher.group(1)))
            {
                System.debug('tag ' + tagMatcher.group(1) + ' is not supported.');

                body = body.replaceAll(tagMatcher.group(0), '');
            }
        }
        System.debug('after replace ' + body);
        return body;
    }
}