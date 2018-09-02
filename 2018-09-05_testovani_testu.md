---
title-prefix: Zonky QA Meetup
title: Testování testů
author: |
    Tomáš Janoušek \
    (tools & infra @ [GoodData](https://www.gooddata.com/company/careers-list))
date: 5. 9. 2018 --- [Zonky QA Meetup](https://www.facebook.com/events/951789721691848/)
---

# Intro

## Proč?

- kód testujeme
- testy jsou kód
- ∴ testy testujeme

## A co infrastruktura?

- testovací infrastruktura je taky kód
- kód testujeme
- ∴ infrastrukturu testujeme

# Testování testů samotných

## Zažijte selhání

::: smaller
> After you have written a test to detect a particular bug, _cause_ the bug
> deliberately and make sure the test complains. This ensures that the test
> will catch the bug if it happens for real.

The Pragmatic Programmer \
[(Andrew Hunt and David Thomas, 2000)]{.x-smaller}
:::

---

```diff
@@ -544,6 +544,7 @@ class Jenkins(object):
 
   """
   url = '/'.join((item, INFO)).lstrip('/')
+  url = quote(url)
   if query:
     url += query
   try:
```

[python-jenkins, git commit 16007e01](https://git.openstack.org/cgit/openstack/python-jenkins/commit/?id=16007e01858cc5d36afdc31d22b5644f91a1f935)

---

::: smaller
```python
@patch.object(jenkins.Jenkins, 'jenkins_open')
def test_unsafe_chars(self, jenkins_mock):
  response = build_jobs_list_responses(
    self.jobs_in_unsafe_name_folders, 'http://example.com/')
  jenkins_mock.side_effect = iter(response)

  jobs_info = self.j.get_all_jobs()

  expected_fullnames = [
    u"my_job1", u"my_job2",
    u"my_folder1/my_job3", u"my_folder1/my_job4",
    u"my_folder1/my spaced folder/my job 5"
  ]
  self.assertEqual(len(expected_fullnames), len(jobs_info))
  got_fullnames = [job[u"fullname"] for job in jobs_info]
  self.assertEqual(expected_fullnames, got_fullnames)
```
:::

---

::: smaller
```diff
@@ -76,3 +98,11 @@ class JenkinsGetAllJobsTest(JenkinsGetJobsTestBase):
   self.assertEqual(len(expected_fullnames), len(jobs_info))
   got_fullnames = [job[u"fullname"] for job in jobs_info]
   self.assertEqual(expected_fullnames, got_fullnames)
+
+  expected_request_urls = [
+    self.make_url('api/json'),
+    self.make_url('job/my_folder1/api/json'),
+    self.make_url('job/my_folder1/job/my%20spaced%20folder/api/json')
+  ]
+  self.assertEqual(expected_request_urls,
+                   self.got_request_urls(jenkins_mock))
```
:::

## Myslete dopředu

- kód se mění
- testy zastarávají

---

::: smaller
> If you are _really_ serious about testing, you might want to appoint a
> _project saboteur_. The saboteur's role is to take a separate copy of the
> source tree, introduce bugs on purpose, and verify that the tests will catch
> them.

The Pragmatic Programmer \
[(Andrew Hunt and David Thomas, 2000)]{.x-smaller}
:::
