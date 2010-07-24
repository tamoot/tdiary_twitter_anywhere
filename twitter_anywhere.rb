# -*- coding: utf-8 -*-
#
# twitter_anywhere.rb - bringing the Twitter communication platform to tDiary
# http://dev.twitter.com/anywhere/begin
#
# Copyright (C) 2010, tamoot <tamoot+tdiary@gmail.com>
# You can redistribute it and/or modify it under GPL2.
#


add_header_proc do 
   if ready_anywhere?

      hovercards = @conf['anywhere.hovercards.selectors'].split(',').collect do |selector|
         "twitter(\"#{selector}\").hovercards();"
      end.join("\n\t")
      <<-ANYWHERE
      <script src="http://platform.twitter.com/anywhere.js?id=#{h @conf['anywhere.id']}&v=1">
      </script>
      <script type="text/javascript">
         twttr.anywhere(function(twitter) {#{hovercards}
         });
      </script>
      ANYWHERE
   else
      ''
   end
end


def follow_api(account)
   if ready_anywhere?
      <<-FOLLOW_API
      <span id="follow-twitterapi"></span>
      <script type="text/javascript">
         twttr.anywhere(function (T) {
            T('#follow-twitterapi').followButton("#{account}");
         });
      </script>
      FOLLOW_API
   else
      ''
   end
end


add_conf_proc( 'anywhere.id', 'Twitter Anywhere ID' ) do
   if @mode == 'saveconf' then
      @conf['anywhere.id'] = @cgi.params['anywhere.id'][0]
      @conf['anywhere.hovercards.selectors'] = @cgi.params['anywhere.hovercards.selectors'][0]
   end

   <<-HTML
   <h3 class="subtitle">Anywhere ID</h3>
   <p><input name="anywhere.id" value="#{h @conf['anywhere.id']}" size="70"></p>
        <p><a href="http://dev.twitter.com/anywhere">Get Anywhere id</a></p>
   <h3 class="subtitle">Hovercards CSS Selector</h3>
   <p><input name="anywhere.hovercards.selectors" value="#{h @conf['anywhere.hovercards.selectors']}" size="70"></p>
        <p>example) div.section p, #tl-text</p>
   HTML
end

def tweet_box(label, content, option = {})
   option.merge!(:height => 120) unless option[:height].to_i > 0
   option.merge!(:width => 480)  unless option[:width].to_i > 0
   r = ''
   if ready_anywhere?
      r << %Q|<span id="tweetbox"></span>|
      r << %Q|<script type="text/javascript">\n|
      r << %Q|   twttr.anywhere(function (T) {\n|
      r << %Q|      T("#tweetbox").tweetBox({\n|
      r << %Q|         height: #{option[:height]},\n|
      r << %Q|         width: #{option[:width]},\n|
      r << %Q|         label: '#{label}',\n|
      r << %Q|         defaultContent: '#{content}'\n|
      r << %Q|      });\n|
      r << %Q|   });\n|
      r << %Q|</script>\n|
   else
      r
   end
end

def ready_anywhere?
   @conf['anywhere.id'] && @conf['anywhere.id'].size > 0 && !@conf.mobile_agent?
end


# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# tab-width: 3
# ruby-indent-level: 3
# End:
# vim: ts=3
