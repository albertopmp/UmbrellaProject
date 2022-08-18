## *Umbre??a Front-end*

#### This docs contains the steps that I took for developing *Umbre??a*, the documentation that served as the baseline of this project and the problems that I encountered throughout the process (as well as their resolution). I decided to divide the whole explanation in different files to make them more specific.

1. In this first step **I hosted my Angular WebApp using S3**. I created a bucket and assigned the corresponding permissions through a Bucket Policy. Then I uploaded the resulting files from executing ng build (create production files) and as a result my WebApp was accessible from `http://umbrella-project.s3-website-eu-west-1.amazonaws.com`

> To help optimize application’s performance and security while effectively managing cost, AWS recommends to also set up Amazon CloudFront to work with the S3 bucket to serve and protect the content. **By design, delivering data out of CloudFront can be more cost effective than delivering it from S3 directly to users, but are still billed for all requests that are handled by S3 when the request passed first through CloudFront when CloudFront does not serve the object from cache.** ([AWS Documentation](https://aws.amazon.com/es/blogs/networking-and-content-delivery/amazon-s3-amazon-cloudfront-a-match-made-in-the-cloud))

2. The first step was to acquire a domain name (`umbrella-project-albertopmp.com`) and set up a hosting zone in **Route53**. In this step I learned that it's really important that the name servers for your domain and the name servers for your hosted zone match. If the name servers don't match, you might need to update your domain name servers to match those listed under your hosted zone ([AWS Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html))

3. As I wanted to use HTTPS with CloudFront I needed to create an SSL Certificate, which had to be [created in `us-east-1`in order to be compatible with CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html). For requesting and validating the certificate with Route53 I followed this [tutorial](https://aws.amazon.com/es/blogs/security/easier-certificate-validation-using-dns-with-aws-certificate-manager), where I used **AWS Certificate Manager (ACM).**

4. Then, to ensure that users access files using only CloudFront URLs, regardless of whether the URLs are signed I created an **Origin Access Identity (OAI)** ([AWS Documentation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html)). When viewers access your Amazon S3 files through CloudFront, **the CloudFront origin access identity gets the files on their behalf.** If viewers request files directly by using Amazon S3 URLs, they’re denied access. Finally, my Angular WebApp was accesible from umbrella-project-albertopmp.com and also www.umbrella-project-albertopmp.com, as the SSL Certificate and Route53 where configured to cover and route both the domain and subdomain

5. I also added security headers to the HTTPS response from CloudFront. For this I used a Lambda@Edge function created in `us-east-1` (otherwise it's impossible to create Lambda@Edge functions). ([AWS Documentation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-how-it-works-tutorial.html#lambda-edge-how-it-works-tutorial-create-function  ))

6. As I was not willing to build, deploy and invalidate each time I wanted to make a change to the front-end, I decided to create a CI/CD workflow using Github Actions. **With this workflow, each time I push to the master branch of the repository, Github Actions builds the Angular application, deploys the app to S3 (deleting the useless objects from previous builds) and then invalidates the CloudFront Cache**

After all these steps I had my WebApp up and running at www.umbrella-project-albertopmp.com. *But this is just the tip of the iceberg!!* **At this point it was time to implement the back-end using more AWS Services. Please go to `02-umbrella_back-end.md` if you want to known more about it :)**


